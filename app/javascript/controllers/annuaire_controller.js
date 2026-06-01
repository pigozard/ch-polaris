import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "panel", "panelContent", "overlay", "count", "searchInput", "typeSelect"]
  static values  = { units: Array }

  connect() {
    this.activePole  = ""
    this.activeType  = ""
    this.searchQuery = ""
    this.render()
    this._handleKeydown = this._onKeydown.bind(this)
    document.addEventListener("keydown", this._handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this._handleKeydown)
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

  esc(str) {
    const d = document.createElement("div")
    d.textContent = str ?? ""
    return d.innerHTML
  }

  cardHTML(unit) {
    const phone = unit.phone
      ? `<span class="annuaire-card__phone">${this.esc(unit.phone)}</span>`
      : ""
    return `
      <button class="annuaire-card"
              data-action="click->annuaire#openPanel"
              data-unit-id="${unit.id}"
              style="--pole-color: ${this.esc(unit.pole_color)}"
              type="button"
              aria-label="Voir ${this.esc(unit.name)}">
        <span class="annuaire-card__name">${this.esc(unit.name)}</span>
        <span class="annuaire-card__type">${this.esc(unit.type_label)}</span>
        ${phone}
      </button>`
  }

  openPanel(event) {
    this._previousFocus = event.currentTarget
    const unitId = parseInt(event.currentTarget.dataset.unitId, 10)
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
        ${allowed.length     ? `<p class="annuaire-panel__list-label">✅ Objets autorisés</p>${this.listHTML(allowed)}`   : ""}
        ${forbidden.length   ? `<p class="annuaire-panel__list-label">🚫 Objets interdits</p>${this.listHTML(forbidden)}` : ""}
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
        ${unit.phone   ? `<div class="annuaire-panel__contact">📞 <a href="tel:${this.esc(unit.phone.replace(/\s/g,""))}">${this.esc(unit.phone)}</a></div>` : ""}
        ${unit.email   ? `<div class="annuaire-panel__contact">✉️ <a href="mailto:${this.esc(unit.email)}">${this.esc(unit.email)}</a></div>`               : ""}
        ${unit.address ? `<div class="annuaire-panel__contact">📍 ${this.esc(unit.address)}</div>`                                                          : ""}
        ${unit.pmr     ? `<div class="annuaire-panel__contact annuaire-panel__pmr">♿ Accessible PMR</div>`                                                  : ""}
        ${unit.parking ? `<div class="annuaire-panel__contact">🅿️ ${this.esc(unit.parking)}</div>`                                                         : ""}
      </div>

      ${schedulesHTML}
      ${sectorsHTML}
      ${regulationHTML}`
  }
}
