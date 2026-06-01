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
