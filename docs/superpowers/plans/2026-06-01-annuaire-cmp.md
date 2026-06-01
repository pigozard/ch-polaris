# Annuaire des unités + Widget CMP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Créer la page `/annuaire` (liste filtrée + panneau latéral) et le widget "Trouver mon CMP" embarqué dans la page patients.

**Architecture:** Page annuaire en one-page avec données JSON inline + Stimulus (pattern carte.html.erb). Widget CMP = formulaire Turbo Frame dans la page patients, réponse via partial. Aucune nouvelle ressource REST : tout passe par PagesController.

**Tech Stack:** Rails 7, Stimulus (Hotwire), Turbo Frames, PostgreSQL, SCSS (polaris.css)

---

## Fichiers créés / modifiés

| Action   | Fichier |
|----------|---------|
| Modifier | `app/models/unit.rb` |
| Modifier | `config/routes.rb` |
| Modifier | `app/controllers/pages_controller.rb` |
| Créer    | `app/views/pages/annuaire.html.erb` |
| Créer    | `app/views/pages/_cmp_result.html.erb` |
| Modifier | `app/views/pages/patients.html.erb` |
| Modifier | `app/views/pages/professionnels.html.erb` |
| Modifier | `app/views/shared/_navbar.html.erb` |
| Créer    | `app/javascript/controllers/annuaire_controller.js` |
| Modifier | `app/javascript/controllers/index.js` |
| Modifier | `app/assets/stylesheets/polaris.css` |
| Créer    | `test/models/unit_test.rb` |
| Créer    | `test/controllers/pages_controller_test.rb` |

---

## Task 1 : Modèle Unit — traductions + sérialisation JSON

**Files:**
- Modify: `app/models/unit.rb`
- Create: `test/models/unit_test.rb`

- [ ] **Step 1.1 : Écrire le test unitaire (qui va échouer)**

Créer `test/models/unit_test.rb` :

```ruby
require "test_helper"

class UnitTest < ActiveSupport::TestCase
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @unit = Unit.create!(
      pole: @pole, name: "CMP Test", unit_type: "cmp",
      phone: "04 00 00 00 00", email: "cmp@test.fr", pmr_accessible: true
    )
  end

  test "type_label retourne la traduction française" do
    assert_equal "Centre Médico-Psychologique", Unit.type_label("cmp")
    assert_equal "Hôpital de jour", Unit.type_label("hdj")
    assert_equal "Hospitalisation ouverte", Unit.type_label("ward_open")
    assert_equal "Hospitalisation fermée", Unit.type_label("ward_closed")
  end

  test "type_label retourne le type brut si inconnu" do
    assert_equal "unknown_type", Unit.type_label("unknown_type")
  end

  test "to_annuaire_json inclut les champs requis" do
    json = @unit.to_annuaire_json(@pole)

    assert_equal @unit.id,                             json[:id]
    assert_equal "CMP Test",                           json[:name]
    assert_equal "cmp",                                json[:type]
    assert_equal "Centre Médico-Psychologique",        json[:type_label]
    assert_equal "pole-test",                          json[:pole_slug]
    assert_equal "Pôle Test",                          json[:pole_name]
    assert_equal "#3B82F6",                            json[:pole_color]
    assert_equal "04 00 00 00 00",                     json[:phone]
    assert_equal "cmp@test.fr",                        json[:email]
    assert_equal true,                                 json[:pmr]
    assert_equal [],                                   json[:schedules]
    assert_equal [],                                   json[:sectors]
    assert_nil json[:regulation]
  end

  test "to_annuaire_json inclut les horaires" do
    Schedule.create!(unit: @unit, schedule_type: "consultation",
                     opens_at: "09:00", closes_at: "17:00", note: "Sur RDV")
    @unit.reload

    json = @unit.to_annuaire_json(@pole)
    schedule = json[:schedules].first

    assert_equal "consultation", schedule[:type]
    assert_equal "09:00",        schedule[:opens_at]
    assert_equal "17:00",        schedule[:closes_at]
    assert_equal "Sur RDV",      schedule[:note]
  end

  test "to_annuaire_json inclut les secteurs" do
    Sector.create!(unit: @unit, postal_code: "76100", city: "Rouen")
    @unit.reload

    json = @unit.to_annuaire_json(@pole)
    sector = json[:sectors].first

    assert_equal "76100", sector[:postal_code]
    assert_equal "Rouen", sector[:city]
  end

  test "to_annuaire_json inclut le règlement visite" do
    UnitRegulation.create!(unit: @unit, max_visitors: 2,
                           allowed_items: "Livres", forbidden_items: "Téléphone",
                           visiting_notes: "Sur RDV uniquement", access_info: "Bâtiment A")
    @unit.reload

    json = @unit.to_annuaire_json(@pole)

    assert_equal 2,                    json[:regulation][:max_visitors]
    assert_equal "Livres",             json[:regulation][:allowed_items]
    assert_equal "Téléphone",          json[:regulation][:forbidden_items]
    assert_equal "Sur RDV uniquement", json[:regulation][:visiting_notes]
    assert_equal "Bâtiment A",         json[:regulation][:access_info]
  end
end
```

- [ ] **Step 1.2 : Lancer les tests — vérifier qu'ils échouent**

```bash
bin/rails test test/models/unit_test.rb
```

Attendu : `NoMethodError: undefined method 'type_label'`

- [ ] **Step 1.3 : Ajouter UNIT_TYPE_LABELS, type_label et to_annuaire_json dans Unit**

Dans `app/models/unit.rb`, après la constante `UNIT_TYPES`, ajouter :

```ruby
UNIT_TYPE_LABELS = {
  "ward_open"     => "Hospitalisation ouverte",
  "ward_closed"   => "Hospitalisation fermée",
  "cmp"           => "Centre Médico-Psychologique",
  "hdj"           => "Hôpital de jour",
  "cattp"         => "CATTP",
  "sessad"        => "SESSAD",
  "empp"          => "Équipe mobile précarité",
  "mobile_team"   => "Équipe mobile",
  "ulpsy"         => "Unité de liaison psychiatrique",
  "cump"          => "Cellule d'urgence médico-psychologique",
  "expert_center" => "Centre expert",
  "utep"          => "Unité transversale ETP",
  "users_house"   => "Maison des usagers",
  "long_stay"     => "Séjour longue durée",
  "csapa"         => "CSAPA",
  "mas"           => "Maison d'accueil spécialisée",
  "camsp"         => "CAMSP",
  "crisis_unit"   => "Unité de crise",
  "perinatal"     => "Unité périnatale"
}.freeze

def self.type_label(type)
  UNIT_TYPE_LABELS.fetch(type, type)
end

def to_annuaire_json(pole)
  {
    id:          id,
    name:        name,
    slug:        slug,
    type:        unit_type,
    type_label:  Unit.type_label(unit_type),
    phone:       phone,
    email:       email,
    pmr:         pmr_accessible,
    address:     address,
    parking:     parking_info,
    description: description,
    pole_slug:   pole.slug,
    pole_name:   pole.name,
    pole_color:  pole.color,
    schedules:   schedules.map { |s|
      {
        type:      s.schedule_type,
        opens_at:  s.opens_at&.strftime("%H:%M"),
        closes_at: s.closes_at&.strftime("%H:%M"),
        note:      s.note
      }
    },
    sectors:     sectors.map { |s| { postal_code: s.postal_code, city: s.city } },
    regulation:  unit_regulation ? {
      max_visitors:    unit_regulation.max_visitors,
      allowed_items:   unit_regulation.allowed_items,
      forbidden_items: unit_regulation.forbidden_items,
      visiting_notes:  unit_regulation.visiting_notes,
      access_info:     unit_regulation.access_info
    } : nil
  }
end
```

- [ ] **Step 1.4 : Relancer les tests — vérifier qu'ils passent**

```bash
bin/rails test test/models/unit_test.rb
```

Attendu : `5 runs, 10 assertions, 0 failures, 0 errors`

---

## Task 2 : Routes + actions PagesController

**Files:**
- Modify: `config/routes.rb`
- Modify: `app/controllers/pages_controller.rb`
- Create: `test/controllers/pages_controller_test.rb`

- [ ] **Step 2.1 : Écrire les tests controller (qui vont échouer)**

Créer `test/controllers/pages_controller_test.rb` :

```ruby
require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @unit = Unit.create!(pole: @pole, name: "CMP Rouen", unit_type: "cmp",
                         phone: "04 00 00 00 00", email: "cmp@test.fr")
    @sector = Sector.create!(unit: @unit, postal_code: "76100", city: "Rouen")
  end

  # ── Annuaire ──────────────────────────────────────────

  test "GET /annuaire répond 200" do
    get annuaire_path
    assert_response :success
  end

  test "GET /annuaire assigne @poles et @units_json" do
    get annuaire_path
    assert_not_nil assigns(:poles)
    assert_not_nil assigns(:units_json)
  end

  test "GET /annuaire inclut les unités dans le JSON" do
    get annuaire_path
    assert_includes assigns(:units_json), "CMP Rouen"
  end

  # ── Trouver mon CMP ───────────────────────────────────

  test "GET /patients/trouver-mon-cmp avec code postal valide retourne le CMP" do
    get trouver_mon_cmp_path, params: { postal_code: "76100" }
    assert_response :success
    assert_includes response.body, "CMP Rouen"
  end

  test "GET /patients/trouver-mon-cmp avec code postal inconnu affiche message non trouvé" do
    get trouver_mon_cmp_path, params: { postal_code: "99999" }
    assert_response :success
    assert_includes response.body, "Aucun CMP"
  end

  test "GET /patients/trouver-mon-cmp avec format invalide affiche message erreur" do
    get trouver_mon_cmp_path, params: { postal_code: "abc" }
    assert_response :success
    assert_includes response.body, "code postal valide"
  end

  test "GET /patients/trouver-mon-cmp sans paramètre affiche message erreur" do
    get trouver_mon_cmp_path, params: { postal_code: "" }
    assert_response :success
    assert_includes response.body, "code postal valide"
  end

  test "GET /patients/trouver-mon-cmp ne retourne pas une unité non-CMP" do
    ward = Unit.create!(pole: @pole, name: "UH Orion 1", unit_type: "ward_open")
    Sector.create!(unit: ward, postal_code: "76100", city: "Rouen")

    get trouver_mon_cmp_path, params: { postal_code: "76100" }
    assert_response :success
    assert_not_includes response.body, "UH Orion 1"
  end
end
```

- [ ] **Step 2.2 : Lancer les tests — vérifier qu'ils échouent**

```bash
bin/rails test test/controllers/pages_controller_test.rb
```

Attendu : `NameError: undefined local variable or method 'annuaire_path'`

- [ ] **Step 2.3 : Ajouter les routes**

Dans `config/routes.rb`, après la ligne `get "carte"`, ajouter :

```ruby
get "annuaire",                 to: "pages#annuaire",        as: :annuaire
get "patients/trouver-mon-cmp", to: "pages#trouver_mon_cmp", as: :trouver_mon_cmp
```

- [ ] **Step 2.4 : Ajouter les actions dans PagesController**

Dans `app/controllers/pages_controller.rb`, ajouter après `def carte` :

```ruby
def annuaire
  @poles = Pole.ordered.includes(units: [:schedules, :sectors, :unit_regulation])
  @units_json = @poles.flat_map { |pole|
    pole.units.sort_by { |u| u.position.to_i }.map { |u| u.to_annuaire_json(pole) }
  }.to_json
end

def trouver_mon_cmp
  @postal_code = params[:postal_code].to_s.strip

  if @postal_code.match?(/\A\d{5}\z/)
    unit_ids = Sector.where(postal_code: @postal_code).pluck(:unit_id)
    @cmps = Unit.where(id: unit_ids, unit_type: "cmp").includes(:schedules, :pole)
    @not_found = @cmps.empty?
  else
    @invalid_format = true
    @cmps = []
  end

  render partial: "pages/cmp_result"
end
```

- [ ] **Step 2.5 : Relancer les tests — vérifier qu'ils passent**

```bash
bin/rails test test/controllers/pages_controller_test.rb
```

Attendu : `8 runs, 10 assertions, 0 failures, 0 errors`

---

## Task 3 : Widget CMP (partial + patients page)

**Files:**
- Create: `app/views/pages/_cmp_result.html.erb`
- Modify: `app/views/pages/patients.html.erb`

- [ ] **Step 3.1 : Créer le partial `_cmp_result.html.erb`**

Créer `app/views/pages/_cmp_result.html.erb` :

```erb
<%= turbo_frame_tag "cmp-result" do %>
  <% if @invalid_format %>
    <p class="cmp-error">Veuillez saisir un code postal valide (5 chiffres).</p>
  <% elsif @not_found %>
    <p class="cmp-not-found">
      Aucun CMP trouvé pour ce code postal.
      Contactez le standard&nbsp;: <a href="tel:0599000000">05 99 00 00 00</a>.
    </p>
  <% else %>
    <% @cmps.each do |cmp| %>
      <div class="cmp-result-card">
        <strong><%= cmp.name %></strong>
        <span class="cmp-pole-badge"
              style="background:<%= cmp.pole.color %>20;color:<%= cmp.pole.color %>">
          <%= cmp.pole.name %>
        </span>
        <% if cmp.phone.present? %>
          <div class="cmp-detail">
            📞 <a href="tel:<%= cmp.phone.gsub(/\s/, "") %>"><%= cmp.phone %></a>
          </div>
        <% end %>
        <% if cmp.email.present? %>
          <div class="cmp-detail">
            ✉️ <a href="mailto:<%= cmp.email %>"><%= cmp.email %></a>
          </div>
        <% end %>
        <% if cmp.address.present? %>
          <div class="cmp-detail">📍 <%= cmp.address %></div>
        <% end %>
        <% consultations = cmp.schedules.select { |s| s.schedule_type == "consultation" } %>
        <% if consultations.any? %>
          <div class="cmp-detail">
            🕐 <%= consultations.map { |s|
              "#{s.opens_at&.strftime("%H:%M")}–#{s.closes_at&.strftime("%H:%M")}" \
              "#{" (#{s.note})" if s.note.present?}"
            }.join(", ") %>
          </div>
        <% end %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

- [ ] **Step 3.2 : Remplacer la hub-card "Trouver mon CMP" dans patients.html.erb**

Localiser le bloc :

```erb
<%# ── LIVE quand la feature "Sectorisation" sera codée (semaine 2) ── %>
<a href="#" class="hub-card hub-card--soon">
  <span class="hub-badge">À venir</span>
  <span class="hub-card-icon" aria-hidden="true">📍</span>
  <span class="hub-card-title">Trouver mon CMP</span>
  <span class="hub-card-desc">Saisissez votre code postal et obtenez le centre médico-psychologique de votre secteur, avec horaires et contact.</span>
  <span class="hub-card-cta">Bientôt disponible</span>
</a>
```

Le remplacer par :

```erb
<%# ── LIVE : Trouver mon CMP ── %>
<div class="hub-card hub-card--live hub-card--cmp">
  <span class="hub-card-icon" aria-hidden="true">📍</span>
  <span class="hub-card-title">Trouver mon CMP</span>
  <span class="hub-card-desc">Saisissez votre code postal pour trouver votre centre médico-psychologique de secteur.</span>

  <%= form_with url: trouver_mon_cmp_path, method: :get,
                data: { turbo_frame: "cmp-result" }, class: "cmp-form" do |f| %>
    <div class="cmp-search-row">
      <%= f.text_field :postal_code, placeholder: "Ex : 76100",
                       pattern: "[0-9]{5}", maxlength: 5, class: "cmp-input",
                       required: true, "aria-label": "Code postal" %>
      <%= f.submit "Rechercher", class: "cmp-btn" %>
    </div>
  <% end %>

  <%= turbo_frame_tag "cmp-result" %>
</div>
```

---

## Task 4 : Page annuaire HTML

**Files:**
- Create: `app/views/pages/annuaire.html.erb`

- [ ] **Step 4.1 : Créer `annuaire.html.erb`**

Créer `app/views/pages/annuaire.html.erb` :

```erb
<%# ═══════════ HERO ═══════════ %>
<section class="hub-hero" aria-labelledby="annuaire-title">
  <div class="container">
    <span class="label">Répertoire</span>
    <h1 id="annuaire-title">Annuaire <span class="hub-hero-accent">des unités</span></h1>
    <p>Retrouvez les coordonnées, horaires et informations pratiques de toutes les unités du CH Polaris.</p>
  </div>
</section>

<%# ═══════════ CONTENU ═══════════ %>
<div class="container"
     data-controller="annuaire"
     data-annuaire-units-value="<%= json_escape(@units_json) %>">

  <section class="section section--no-border">

    <%# ── Filtres ── %>
    <div class="annuaire-filters">
      <div class="annuaire-pole-chips" role="group" aria-label="Filtrer par pôle">
        <button class="annuaire-chip annuaire-chip--active"
                data-action="click->annuaire#filterPole"
                data-pole=""
                type="button">Tous les pôles</button>
        <% @poles.each do |pole| %>
          <button class="annuaire-chip"
                  data-action="click->annuaire#filterPole"
                  data-pole="<%= pole.slug %>"
                  style="--chip-color: <%= pole.color %>"
                  type="button">
            <%= pole.name %>
          </button>
        <% end %>
      </div>

      <div class="annuaire-filters-right">
        <select class="annuaire-type-select"
                data-annuaire-target="typeSelect"
                data-action="change->annuaire#filterType"
                aria-label="Filtrer par type">
          <option value="">Tous les types</option>
          <% Unit::UNIT_TYPE_LABELS.each do |type, label| %>
            <option value="<%= type %>"><%= label %></option>
          <% end %>
        </select>

        <input type="search"
               class="annuaire-search-input"
               placeholder="Rechercher une unité…"
               data-annuaire-target="searchInput"
               data-action="input->annuaire#filterSearch"
               autocomplete="off"
               aria-label="Rechercher par nom">
      </div>
    </div>

    <%# ── Grille (peuplée par Stimulus) ── %>
    <div class="annuaire-grid"
         data-annuaire-target="grid"
         aria-live="polite"
         aria-label="Liste des unités">
    </div>

    <p class="annuaire-count" data-annuaire-target="count" aria-live="polite"></p>

  </section>
</div>

<%# ═══════════ PANNEAU LATÉRAL ═══════════ %>
<div class="annuaire-panel"
     data-annuaire-target="panel"
     role="dialog"
     aria-modal="true"
     aria-labelledby="annuaire-panel-title"
     tabindex="-1"
     hidden>
  <div class="annuaire-panel-inner">
    <button class="annuaire-panel-close"
            data-action="click->annuaire#closePanel"
            aria-label="Fermer le panneau"
            type="button">✕</button>
    <div data-annuaire-target="panelContent"></div>
  </div>
</div>

<div class="annuaire-overlay"
     data-annuaire-target="overlay"
     data-action="click->annuaire#closePanel"
     hidden></div>
```

---

## Task 5 : Stimulus controller annuaire

**Files:**
- Create: `app/javascript/controllers/annuaire_controller.js`
- Modify: `app/javascript/controllers/index.js`

- [ ] **Step 5.1 : Créer `annuaire_controller.js`**

Créer `app/javascript/controllers/annuaire_controller.js` :

```js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "panel", "panelContent", "overlay", "count", "searchInput", "typeSelect"]
  static values  = { units: Array }

  connect() {
    this.activePole  = ""
    this.activeType  = ""
    this.searchQuery = ""
    this.render()
  }

  filterPole(event) {
    this.element.querySelectorAll(".annuaire-chip")
      .forEach(c => c.classList.remove("annuaire-chip--active"))
    event.currentTarget.classList.add("annuaire-chip--active")
    this.activePole = event.currentTarget.dataset.pole
    this.render()
  }

  filterType(event) {
    this.activeType = event.currentTarget.value
    this.render()
  }

  filterSearch(event) {
    this.searchQuery = event.currentTarget.value.toLowerCase()
    this.render()
  }

  render() {
    const units = this.filteredUnits()

    if (units.length === 0) {
      this.gridTarget.innerHTML = `<p class="annuaire-empty">Aucune unité ne correspond à votre recherche.</p>`
      this.countTarget.textContent = ""
      return
    }

    this.gridTarget.innerHTML = units.map(u => this.cardHTML(u)).join("")
    const n = units.length
    this.countTarget.textContent = `${n} unité${n > 1 ? "s" : ""}`
  }

  filteredUnits() {
    return this.unitsValue.filter(u => {
      const matchPole   = !this.activePole  || u.pole_slug === this.activePole
      const matchType   = !this.activeType  || u.type      === this.activeType
      const matchSearch = !this.searchQuery || u.name.toLowerCase().includes(this.searchQuery)
      return matchPole && matchType && matchSearch
    })
  }

  cardHTML(unit) {
    const phone = unit.phone
      ? `<span class="annuaire-card__phone">${unit.phone}</span>`
      : ""
    return `
      <button class="annuaire-card"
              data-action="click->annuaire#openPanel"
              data-unit-id="${unit.id}"
              style="--pole-color: ${unit.pole_color}"
              type="button"
              aria-label="Voir ${unit.name}">
        <span class="annuaire-card__name">${unit.name}</span>
        <span class="annuaire-card__type">${unit.type_label}</span>
        ${phone}
      </button>`
  }

  openPanel(event) {
    const unitId = parseInt(event.currentTarget.dataset.unitId)
    const unit   = this.unitsValue.find(u => u.id === unitId)
    if (!unit) return

    this.panelContentTarget.innerHTML = this.panelHTML(unit)
    this.panelTarget.hidden  = false
    this.overlayTarget.hidden = false
    document.body.style.overflow = "hidden"
    this.panelTarget.focus()
  }

  closePanel() {
    this.panelTarget.hidden  = true
    this.overlayTarget.hidden = true
    document.body.style.overflow = ""
  }

  panelHTML(unit) {
    const typeLabels = { consultation: "Consultations", visiting: "Visites", phone: "Téléphone" }

    const schedulesHTML = unit.schedules.length ? `
      <div class="annuaire-panel__section">
        <h3 class="annuaire-panel__section-title">Horaires</h3>
        ${unit.schedules.map(s => `
          <div class="annuaire-panel__schedule">
            <span class="annuaire-panel__schedule-type">${typeLabels[s.type] || s.type}</span>
            <span>${s.opens_at}–${s.closes_at}${s.note ? ` <em>(${s.note})</em>` : ""}</span>
          </div>`).join("")}
      </div>` : ""

    const sectorsHTML = unit.sectors.length ? `
      <div class="annuaire-panel__section">
        <h3 class="annuaire-panel__section-title">Secteurs couverts</h3>
        <div class="annuaire-panel__sectors">
          ${unit.sectors.map(s =>
            `<span class="annuaire-panel__sector-tag">${s.city} (${s.postal_code})</span>`
          ).join("")}
        </div>
      </div>` : ""

    const reg = unit.regulation
    const regulationHTML = reg ? `
      <div class="annuaire-panel__section">
        <h3 class="annuaire-panel__section-title">Informations pratiques</h3>
        ${reg.max_visitors     ? `<p><strong>Visiteurs max&nbsp;:</strong> ${reg.max_visitors}</p>`       : ""}
        ${reg.visiting_notes   ? `<p>${reg.visiting_notes}</p>`                                           : ""}
        ${reg.allowed_items    ? `<p><strong>Objets autorisés&nbsp;:</strong> ${reg.allowed_items}</p>`   : ""}
        ${reg.forbidden_items  ? `<p><strong>Objets interdits&nbsp;:</strong> ${reg.forbidden_items}</p>` : ""}
        ${reg.access_info      ? `<p><strong>Accès&nbsp;:</strong> ${reg.access_info}</p>`                : ""}
      </div>` : ""

    return `
      <div class="annuaire-panel__header">
        <span class="annuaire-panel__pole-badge"
              style="background:${unit.pole_color}20;color:${unit.pole_color}">
          ${unit.pole_name}
        </span>
        <h2 class="annuaire-panel__title" id="annuaire-panel-title">${unit.name}</h2>
        <p class="annuaire-panel__type">${unit.type_label}</p>
      </div>

      ${unit.description ? `<div class="annuaire-panel__section"><p class="annuaire-panel__desc">${unit.description}</p></div>` : ""}

      <div class="annuaire-panel__section">
        ${unit.phone   ? `<div class="annuaire-panel__contact">📞 <a href="tel:${unit.phone.replace(/\s/g,"")}">${unit.phone}</a></div>` : ""}
        ${unit.email   ? `<div class="annuaire-panel__contact">✉️ <a href="mailto:${unit.email}">${unit.email}</a></div>`               : ""}
        ${unit.address ? `<div class="annuaire-panel__contact">📍 ${unit.address}</div>`                                               : ""}
        ${unit.pmr     ? `<div class="annuaire-panel__contact annuaire-panel__pmr">♿ Accessible PMR</div>`                             : ""}
        ${unit.parking ? `<div class="annuaire-panel__contact">🅿️ ${unit.parking}</div>`                                              : ""}
      </div>

      ${schedulesHTML}
      ${sectorsHTML}
      ${regulationHTML}`
  }
}
```

- [ ] **Step 5.2 : Enregistrer le controller dans index.js**

Dans `app/javascript/controllers/index.js`, ajouter après la ligne `TabsController` :

```js
import AnnuaireController from "./annuaire_controller"
application.register("annuaire", AnnuaireController)
```

---

## Task 6 : CSS — annuaire + widget CMP

**Files:**
- Modify: `app/assets/stylesheets/polaris.css`

- [ ] **Step 6.1 : Ajouter les styles à la fin de `polaris.css`**

Ajouter à la fin du fichier `app/assets/stylesheets/polaris.css` :

```css
/* ═══════════════════════════════════════
   ANNUAIRE DES UNITÉS
   ═══════════════════════════════════════ */

/* ── Filtres ── */
.annuaire-filters {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 40px;
  padding-bottom: 24px;
  border-bottom: 1px solid var(--border);
}
.annuaire-pole-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.annuaire-chip {
  padding: 6px 14px;
  border-radius: 20px;
  border: 1.5px solid var(--border);
  background: var(--bg);
  color: var(--body);
  font-size: 0.83rem;
  font-weight: 500;
  font-family: var(--font-body);
  cursor: pointer;
  transition: background 0.15s, border-color 0.15s, color 0.15s;
}
.annuaire-chip:hover {
  border-color: var(--chip-color, var(--teal));
  color: var(--chip-color, var(--teal));
}
.annuaire-chip--active {
  background: var(--chip-color, var(--teal));
  border-color: var(--chip-color, var(--teal));
  color: white;
}
.annuaire-filters-right { display: flex; gap: 10px; align-items: center; }
.annuaire-type-select,
.annuaire-search-input {
  padding: 7px 12px;
  border: 1.5px solid var(--border);
  border-radius: 7px;
  font-size: 0.85rem;
  font-family: var(--font-body);
  background: var(--bg);
  color: var(--ink);
}
.annuaire-type-select:focus,
.annuaire-search-input:focus { outline: none; border-color: var(--teal); }

/* ── Grille de cartes ── */
.annuaire-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 16px;
  min-height: 120px;
}
.annuaire-card {
  display: flex;
  flex-direction: column;
  gap: 5px;
  padding: 20px;
  border: 1.5px solid var(--border);
  border-left: 4px solid var(--pole-color, var(--teal));
  border-radius: 8px;
  background: var(--bg);
  cursor: pointer;
  text-align: left;
  font-family: var(--font-body);
  transition: box-shadow 0.15s, transform 0.15s;
}
.annuaire-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(17,24,39,0.08);
}
.annuaire-card__name { font-weight: 600; font-size: 0.95rem; color: var(--ink); }
.annuaire-card__type { font-size: 0.78rem; color: var(--muted); }
.annuaire-card__phone { font-size: 0.82rem; color: var(--teal-dark); margin-top: 4px; }
.annuaire-empty {
  grid-column: 1 / -1;
  text-align: center;
  color: var(--muted);
  font-size: 0.95rem;
  padding: 40px 0;
}
.annuaire-count { margin-top: 16px; font-size: 0.82rem; color: var(--muted); }

/* ── Panneau latéral ── */
.annuaire-panel {
  position: fixed;
  top: 0;
  right: 0;
  height: 100%;
  width: min(480px, 95vw);
  background: var(--bg);
  border-left: 1px solid var(--border);
  box-shadow: -8px 0 32px rgba(17,24,39,0.12);
  z-index: 500;
  overflow-y: auto;
  overscroll-behavior: contain;
}
.annuaire-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17,24,39,0.3);
  z-index: 499;
}
.annuaire-panel-inner { padding: 24px 28px 40px; position: relative; }
.annuaire-panel-close {
  position: sticky;
  top: 0;
  float: right;
  background: var(--bg);
  border: 1.5px solid var(--border);
  border-radius: 50%;
  width: 32px;
  height: 32px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.9rem;
  color: var(--muted);
  z-index: 1;
  font-family: var(--font-body);
}
.annuaire-panel__header {
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--border);
}
.annuaire-panel__pole-badge {
  display: inline-block;
  font-size: 0.72rem;
  font-weight: 600;
  padding: 3px 10px;
  border-radius: 20px;
  margin-bottom: 10px;
}
.annuaire-panel__title {
  font-family: var(--font-display);
  font-size: 1.6rem;
  font-weight: 400;
  color: var(--ink);
  margin: 0 0 4px;
}
.annuaire-panel__type { font-size: 0.85rem; color: var(--muted); margin: 0; }
.annuaire-panel__section {
  padding: 16px 0;
  border-bottom: 1px solid var(--border);
}
.annuaire-panel__section:last-child { border-bottom: none; }
.annuaire-panel__section p { margin: 0 0 8px; font-size: 0.88rem; color: var(--body); }
.annuaire-panel__section-title {
  font-size: 0.72rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--muted);
  margin: 0 0 12px;
}
.annuaire-panel__contact { font-size: 0.9rem; color: var(--body); margin-bottom: 6px; }
.annuaire-panel__contact a { color: var(--teal-dark); text-decoration: none; }
.annuaire-panel__contact a:hover { text-decoration: underline; }
.annuaire-panel__pmr { color: var(--teal-dark); font-weight: 500; }
.annuaire-panel__desc { font-size: 0.9rem; color: var(--body); margin: 0; }
.annuaire-panel__schedule {
  display: flex;
  gap: 12px;
  font-size: 0.88rem;
  margin-bottom: 6px;
  color: var(--body);
}
.annuaire-panel__schedule-type { font-weight: 500; min-width: 100px; color: var(--ink); }
.annuaire-panel__sectors { display: flex; flex-wrap: wrap; gap: 6px; }
.annuaire-panel__sector-tag {
  font-size: 0.78rem;
  background: var(--bg-alt);
  border: 1px solid var(--border);
  border-radius: 5px;
  padding: 2px 8px;
  color: var(--body);
}

/* ═══════════════════════════════════════
   WIDGET CMP (page patients)
   ═══════════════════════════════════════ */
.hub-card--cmp { cursor: default; }
.hub-card--cmp:hover { transform: none; box-shadow: none; border-color: var(--border); }
.cmp-form { width: 100%; }
.cmp-search-row { display: flex; gap: 8px; margin: 14px 0 0; }
.cmp-input {
  flex: 1;
  max-width: 110px;
  padding: 8px 10px;
  border: 1.5px solid var(--border);
  border-radius: 7px;
  font-size: 0.9rem;
  font-family: var(--font-body);
  text-align: center;
  letter-spacing: 0.08em;
}
.cmp-input:focus { outline: none; border-color: var(--teal); }
.cmp-btn {
  padding: 8px 16px;
  background: var(--teal);
  color: white;
  border: none;
  border-radius: 7px;
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  font-family: var(--font-body);
}
.cmp-btn:hover { background: var(--teal-dark); }
.cmp-result-card {
  background: var(--teal-light);
  border: 1px solid #b2d8d7;
  border-radius: 8px;
  padding: 14px 16px;
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.cmp-result-card strong { font-size: 0.95rem; color: var(--ink); }
.cmp-pole-badge {
  display: inline-block;
  font-size: 0.68rem;
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 20px;
  margin-bottom: 2px;
  align-self: flex-start;
}
.cmp-detail { font-size: 0.85rem; color: var(--body); }
.cmp-detail a { color: var(--teal-dark); text-decoration: none; }
.cmp-detail a:hover { text-decoration: underline; }
.cmp-error {
  font-size: 0.85rem;
  margin-top: 10px;
  padding: 10px 14px;
  border-radius: 7px;
  color: #b91c1c;
  background: #fef2f2;
  border: 1px solid #fecaca;
}
.cmp-not-found {
  font-size: 0.85rem;
  margin-top: 10px;
  padding: 10px 14px;
  border-radius: 7px;
  color: var(--body);
  background: var(--bg-alt);
  border: 1px solid var(--border);
}

/* ── Responsive annuaire ── */
@media (max-width: 720px) {
  .annuaire-filters { flex-direction: column; align-items: stretch; }
  .annuaire-filters-right { flex-direction: column; }
  .annuaire-type-select,
  .annuaire-search-input { width: 100%; }
}
```

---

## Task 7 : Activation navbar + hub cards

**Files:**
- Modify: `app/views/shared/_navbar.html.erb`
- Modify: `app/views/pages/professionnels.html.erb`
- Modify: `app/views/pages/patients.html.erb` (hub-card annuaire)

- [ ] **Step 7.1 : Ajouter l'onglet "Annuaire" dans la navbar**

Dans `app/views/shared/_navbar.html.erb`, après `<li><%= link_to "Professionnels"... %>`, ajouter :

```erb
<li><%= link_to "Annuaire", annuaire_path, class: "nav-link" %></li>
```

- [ ] **Step 7.2 : Activer la hub-card annuaire dans professionnels.html.erb**

Localiser le bloc :

```erb
<%# ── LIVE quand l'annuaire sera codé (semaine 1) ── %>
<a href="#" class="hub-card hub-card--soon">
  <span class="hub-badge">À venir</span>
  <span class="hub-card-icon" aria-hidden="true">🗂️</span>
  <span class="hub-card-title">Annuaire des unités</span>
  <span class="hub-card-desc">Spécialités, contacts directs et secrétariats de l'ensemble des unités, filtrables par pôle et par type.</span>
  <span class="hub-card-cta">Bientôt disponible</span>
</a>
```

Le remplacer par :

```erb
<%# ── LIVE : Annuaire des unités ── %>
<%= link_to annuaire_path, class: "hub-card hub-card--live" do %>
  <span class="hub-card-icon" aria-hidden="true">🗂️</span>
  <span class="hub-card-title">Annuaire des unités</span>
  <span class="hub-card-desc">Spécialités, contacts directs et secrétariats de l'ensemble des unités, filtrables par pôle et par type.</span>
  <span class="hub-card-cta">Consulter l'annuaire →</span>
<% end %>
```

- [ ] **Step 7.3 : Activer la hub-card annuaire dans patients.html.erb**

Localiser le bloc :

```erb
<%# ── LIVE quand l'annuaire sera codé (semaine 1) ── %>
<a href="#" class="hub-card hub-card--soon">
  <span class="hub-badge">À venir</span>
  <span class="hub-card-icon" aria-hidden="true">🗂️</span>
  <span class="hub-card-title">Annuaire des unités</span>
  <span class="hub-card-desc">Horaires de visite et coordonnées de chaque unité, filtrables par pôle et par type de prise en charge.</span>
  <span class="hub-card-cta">Bientôt disponible</span>
</a>
```

Le remplacer par :

```erb
<%# ── LIVE : Annuaire des unités ── %>
<%= link_to annuaire_path, class: "hub-card hub-card--live" do %>
  <span class="hub-card-icon" aria-hidden="true">🗂️</span>
  <span class="hub-card-title">Annuaire des unités</span>
  <span class="hub-card-desc">Horaires de visite et coordonnées de chaque unité, filtrables par pôle et par type de prise en charge.</span>
  <span class="hub-card-cta">Consulter l'annuaire →</span>
<% end %>
```

- [ ] **Step 7.4 : Lancer la suite de tests complète**

```bash
bin/rails test
```

Attendu : toutes les suites passent, 0 failures, 0 errors.

- [ ] **Step 7.5 : Lancer le serveur et vérifier en local**

```bash
bin/dev
```

Vérifier :
- `/annuaire` charge avec la grille de toutes les unités
- Les chips pôles filtrent la grille
- Le dropdown type filtre la grille
- La recherche texte filtre la grille
- Cliquer une carte ouvre le panneau latéral
- Le panneau affiche contacts, horaires, secteurs si présents
- Cliquer l'overlay ou ✕ ferme le panneau
- `/patients` → la carte "Trouver mon CMP" est live, saisir `76100` retourne un CMP
- `/patients` → la carte "Annuaire" est cliquable et redirige vers `/annuaire`
- `/professionnels` → la carte "Annuaire" est cliquable et redirige vers `/annuaire`
- Navbar affiche bien le lien "Annuaire"
