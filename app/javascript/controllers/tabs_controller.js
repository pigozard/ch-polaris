import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["btn", "panel"]

  connect() {
    this.activate(this.btnTargets[0])
  }

  select(event) {
    this.activate(event.currentTarget)
  }

  navigate(event) {
    const btns = this.btnTargets
    const current = btns.indexOf(event.currentTarget)
    let next

    if (event.key === "ArrowRight") next = (current + 1) % btns.length
    if (event.key === "ArrowLeft")  next = (current - 1 + btns.length) % btns.length
    if (event.key === "Home")       next = 0
    if (event.key === "End")        next = btns.length - 1

    if (next !== undefined) {
      event.preventDefault()
      btns[next].focus()
      this.activate(btns[next])
    }
  }

  activate(btn) {
    const tab = btn.dataset.tab

    this.btnTargets.forEach(b => {
      b.classList.remove("active")
      b.setAttribute("aria-selected", "false")
    })

    this.panelTargets.forEach(p => {
      p.classList.remove("active")
      p.setAttribute("aria-hidden", "true")
    })

    btn.classList.add("active")
    btn.setAttribute("aria-selected", "true")

    const panel = this.panelTargets.find(p => p.dataset.tab === tab)
    if (panel) {
      panel.classList.add("active")
      panel.setAttribute("aria-hidden", "false")
    }
  }
}
