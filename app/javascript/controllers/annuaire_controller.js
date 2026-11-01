import { Controller } from "@hotwired/stimulus"

// Texte comparable : minuscules, sans accents, ponctuation remplacée par des espaces
// (« Dépression ! » → « depression »)
const normalize = (str) => (str ?? "")
  .toLowerCase()
  .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
  .replace(/[^a-z0-9]+/g, " ")
  .trim()

// Un mot-clé correspond à la recherche si :
// - il apparaît en mots entiers dans la phrase tapée (« mon pere » → « pere », mais pas « espere ») ;
// - ou s'il commence par ce qui est en train d'être tapé (« accouch » → « accouchement »).
const keywordMatches = (query, keyword) => {
  const k = normalize(keyword)
  return ` ${query} `.includes(` ${k} `) || (query.length >= 3 && k.startsWith(query))
}

export default class extends Controller {
  static targets = ["grid", "panel", "panelContent", "overlay", "count", "searchInput", "typeSelect",
                    "emergency"]
  static values  = { units: Array }

  connect() {
    this.activePole  = ""
    this.activeType  = ""
    this.searchQuery = ""
    this.render()
    this._handleKeydown = this._onKeydown.bind(this)
    this._handleCardClick = this._onCardClick.bind(this)
    document.addEventListener("keydown", this._handleKeydown)
    this.gridTarget.addEventListener("click", this._handleCardClick)
  }

  disconnect() {
    document.removeEventListener("keydown", this._handleKeydown)
    this.gridTarget.removeEventListener("click", this._handleCardClick)
  }

  _onCardClick(event) {
    const card = event.target.closest(".annuaire-card")
    if (!card) return
    const unitId = parseInt(card.dataset.unitId, 10)
    const unit   = this.unitsValue.find(u => u.id === unitId)
    if (!unit) return
    this._previousFocus = card
    this.panelContentTarget.innerHTML = this.panelHTML(unit)
    this.panelTarget.hidden   = false
    this.overlayTarget.hidden = false
    document.body.style.overflow = "hidden"
    this.panelTarget.focus()
  }

  _onKeydown(event) {
    if (event.key === "Escape" && !this.panelTarget.hidden) {
      this.closePanel()
    }
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
    this.searchQuery = normalize(event.currentTarget.value)
    this.render()
  }

  render() {
    this.renderEmergency()
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
      const matchSearch = !this.searchQuery || this.matchesName(u) || this.matchedNeeds(u).length > 0
      return matchPole && matchType && matchSearch
    })
  }

  // Recherche par nom ou par type d'unité (« Persée », « cmp », « hôpital de jour »)
  matchesName(unit) {
    return normalize(`${unit.name} ${unit.type_label}`).includes(this.searchQuery)
  }

  // Besoins de l'unité dont un mot-clé correspond (« bipolaire » → « Troubles bipolaires »)
  matchedNeeds(unit) {
    if (!this.searchQuery) return []
    return (unit.needs || []).filter(need =>
      need.keywords.some(keyword => keywordMatches(this.searchQuery, keyword)))
  }

  // Encadré d'urgence (15, 3114, urgences psy) affiché pour toute recherche,
  // quel que soit le mot tapé : la personne a l'information même avec un mauvais mot-clé
  renderEmergency() {
    this.emergencyTarget.hidden = this.searchQuery === ""
  }

  esc(str) {
    const d = document.createElement("div")
    d.textContent = str ?? ""
    return d.innerHTML
  }

  cardHTML(unit) {
    const phone = unit.phone
      ? `<span class="annuaire-card__phone">${this.esc(unit.phone)}</span>`
      : ""
    const needs = this.matchedNeeds(unit).map(n => n.label)
    const reason = needs.length
      ? `<span class="annuaire-card__reason">Proposé pour : ${this.esc(needs.join(", "))}</span>`
      : ""
    return `
      <button class="annuaire-card"
              data-unit-id="${unit.id}"
              style="--pole-color: ${this.esc(unit.pole_color)}"
              type="button"
              aria-label="Voir ${this.esc(unit.name)}">
        <span class="annuaire-card__name">${this.esc(unit.name)}</span>
        <span class="annuaire-card__type">${this.esc(unit.type_label)}</span>
        ${reason}
        ${phone}
      </button>`
  }

  closePanel() {
    this.panelTarget.hidden  = true
    this.overlayTarget.hidden = true
    document.body.style.overflow = ""
    this._previousFocus?.focus()
  }

  parseList(val) {
    if (!val) return []
    try { const p = JSON.parse(val); return Array.isArray(p) ? p : [val] }
    catch { return [val] }
  }

  listHTML(items) {
    return `<ul class="annuaire-panel__list">${items.map(i => `<li>${this.esc(i)}</li>`).join("")}</ul>`
  }

  panelHTML(unit) {
    const typeLabels = { consultation: "Consultations", visiting: "Visites", phone: "Téléphone" }

    const schedulesHTML = unit.schedules.length ? `
      <div class="annuaire-panel__section">
        <h3 class="annuaire-panel__section-title">Horaires</h3>
        ${unit.schedules.map(s => `
          <div class="annuaire-panel__schedule">
            <span class="annuaire-panel__schedule-type">${this.esc(typeLabels[s.type] || s.type)}</span>
            <span class="annuaire-panel__schedule-hours">${this.esc(s.opens_at)} – ${this.esc(s.closes_at)}</span>
            ${s.note ? `<span class="annuaire-panel__schedule-note">${this.esc(s.note)}</span>` : ""}
          </div>`).join("")}
      </div>` : ""

    const sectorsHTML = unit.sectors.length ? `
      <div class="annuaire-panel__section">
        <h3 class="annuaire-panel__section-title">Secteurs couverts</h3>
        <div class="annuaire-panel__sectors">
          ${unit.sectors.map(s =>
            `<span class="annuaire-panel__sector-tag">${this.esc(s.city)} (${this.esc(s.postal_code)})</span>`
          ).join("")}
        </div>
      </div>` : ""

    const reg = unit.regulation
    const forbidden = reg ? this.parseList(reg.forbidden_items) : []
    const allowed   = reg ? this.parseList(reg.allowed_items)   : []
    const regulationHTML = reg ? `
      <div class="annuaire-panel__section">
        <h3 class="annuaire-panel__section-title">Informations pratiques</h3>
        ${reg.max_visitors   ? `<p><strong>Visiteurs maximum&nbsp;:</strong> ${this.esc(String(reg.max_visitors))}</p>` : ""}
        ${reg.visiting_notes ? `<p class="annuaire-panel__reg-note">${this.esc(reg.visiting_notes)}</p>`               : ""}
        ${allowed.length     ? `<p class="annuaire-panel__list-label"><i class="fa-solid fa-circle-check icon-allowed" aria-hidden="true"></i> Objets autorisés</p>${this.listHTML(allowed)}`   : ""}
        ${forbidden.length   ? `<p class="annuaire-panel__list-label"><i class="fa-solid fa-ban icon-forbidden" aria-hidden="true"></i> Objets interdits</p>${this.listHTML(forbidden)}` : ""}
        ${reg.access_info    ? `<p><strong>Accès&nbsp;:</strong> ${this.esc(reg.access_info)}</p>`                     : ""}
      </div>` : ""

    return `
      <div class="annuaire-panel__header">
        <span class="annuaire-panel__pole-badge"
              style="background:${this.esc(unit.pole_color)}20;color:${this.esc(unit.pole_color)}">
          ${this.esc(unit.pole_name)}
        </span>
        <h2 class="annuaire-panel__title" id="annuaire-panel-title">${this.esc(unit.name)}</h2>
        <p class="annuaire-panel__type">${this.esc(unit.type_label)}</p>
      </div>

      ${unit.description ? `<div class="annuaire-panel__section"><p class="annuaire-panel__desc">${this.esc(unit.description)}</p></div>` : ""}

      <div class="annuaire-panel__section">
        ${unit.phone   ? `<div class="annuaire-panel__contact"><i class="fa-solid fa-phone" aria-hidden="true"></i> <a href="tel:${this.esc(unit.phone.replace(/\s/g,""))}">${this.esc(unit.phone)}</a></div>` : ""}
        ${unit.email   ? `<div class="annuaire-panel__contact"><i class="fa-solid fa-envelope" aria-hidden="true"></i> <a href="mailto:${this.esc(unit.email)}">${this.esc(unit.email)}</a></div>`               : ""}
        ${unit.address ? `<div class="annuaire-panel__contact"><i class="fa-solid fa-location-dot" aria-hidden="true"></i> ${this.esc(unit.address)}</div>`                                                          : ""}
        ${unit.pmr     ? `<div class="annuaire-panel__contact annuaire-panel__pmr"><i class="fa-solid fa-wheelchair" aria-hidden="true"></i> Accessible PMR</div>`                                                  : ""}
        ${unit.parking ? `<div class="annuaire-panel__contact">🅿️ ${this.esc(unit.parking)}</div>`                                                         : ""}
      </div>

      ${schedulesHTML}
      ${sectorsHTML}
      ${regulationHTML}`
  }
}
