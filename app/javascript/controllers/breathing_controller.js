import { Controller } from "@hotwired/stimulus"

// Cohérence cardiaque : « Respirez avec Clara »
// Rythme fixe 5 s / 5 s (6 respirations par minute), séance de 3, 5 ou 10 minutes.

const NS = "http://www.w3.org/2000/svg"
const STORE_KEY = "souffle365"
const PREP = 4          // secondes pour « Videz l'air » avant la première inspiration
const ARC = 1218.94     // 2 × π × 194 (périmètre de l'arc de progression)
const HEAD = { cx: 200, cy: 186, rx: 48, ry: 62 }

// Courbe douce (sinusoïdale) : départ et arrivée lents, comme une vraie respiration
const ease = (p) => 0.5 - 0.5 * Math.cos(Math.PI * p)
const fmtN = (n) => n.toLocaleString("fr-FR", { maximumFractionDigits: 1 })
const fmtT = (s) => {
  s = Math.max(0, Math.ceil(s))
  return String(Math.floor(s / 60)).padStart(2, "0") + ":" + String(s % 60).padStart(2, "0")
}
const todayKey = () => {
  const d = new Date()
  return [d.getFullYear(), String(d.getMonth() + 1).padStart(2, "0"), String(d.getDate()).padStart(2, "0")].join("-")
}

// Angle « flottant » d'une mèche : vers l'extérieur et vers le haut
function liftAngle(u, v) {
  let a = Math.atan2(-u, v - 0.55) * 180 / Math.PI
  if (u < 0 && a < 0) a += 360
  if (u >= 0 && a > 0) a -= 360
  return a
}

export default class extends Controller {
  static targets = [
    "stage", "who", "hairBack", "hairFront", "discCool", "discWarm", "arc", "bubbles",
    "mouthClosed", "mouthOpen", "phase", "hint", "count", "barFill", "cycleTxt", "timeTxt",
    "primary", "stop", "settings", "duration", "dot", "todayTxt", "today"
  ]

  connect() {
    // Générateur pseudo-aléatoire à graine fixe : la chevelure est identique à chaque chargement
    this.seed = 11

    this.mq = window.matchMedia("(prefers-reduced-motion: reduce)")
    this.reduced = this.mq.matches
    this.onMotionChange = (e) => { this.reduced = e.matches }
    this.mq.addEventListener?.("change", this.onMotionChange)

    this.loadStore()
    const s0 = this.store.settings || {}
    this.settings = { inh: 5, exh: 5, min: [3, 5, 10].includes(s0.min) ? s0.min : 5 }

    this.buildHair()
    this.buildBubbles()

    // État de la séance
    this.state = "idle" // idle | prep | run | paused | done
    this.pausedFrom = null
    this.elapsed = 0
    this.prepLeft = 0
    this.prepFrom = 0.5
    this.phaseName = "idle"
    this.phaseP = 0
    this.phaseRemain = 0
    // bT = cible « poumons » (0 vide, 1 plein) ; bD = valeur affichée, lissée
    this.bT = 0.5
    this.bD = 0.5
    this.prevBT = 0.5
    this.mouth = 0
    this.clock = 0
    this.wakeLock = null
    this.cache = {}

    // Écouteurs globaux : retirés dans disconnect() quand Turbo change de page
    this.onKeydown = (e) => {
      if (e.code === "Space" && e.target === document.body) {
        e.preventDefault()
        this.toggle()
      }
    }
    this.onVisibility = () => {
      if (document.hidden && (this.state === "run" || this.state === "prep")) this.pause()
    }
    document.addEventListener("keydown", this.onKeydown)
    document.addEventListener("visibilitychange", this.onVisibility)

    this.syncControls()
    this.renderToday()
    this.total = this.plannedTotal()
    this.ui()
    this.draw(0)

    this.last = performance.now()
    this.frame = this.frame.bind(this)
    this.rafId = requestAnimationFrame(this.frame)
  }

  disconnect() {
    cancelAnimationFrame(this.rafId)
    this.lockOff()
    document.removeEventListener("keydown", this.onKeydown)
    document.removeEventListener("visibilitychange", this.onVisibility)
    this.mq.removeEventListener?.("change", this.onMotionChange)
  }

  // ── Actions (boutons et choix de durée) ──────────────

  toggle() {
    if (this.state === "idle" || this.state === "done") this.start()
    else if (this.state === "prep" || this.state === "run") this.pause()
    else if (this.state === "paused") this.resume()
  }

  stop() {
    this.state = "idle"
    this.elapsed = 0
    this.pausedFrom = null
    this.total = this.plannedTotal()
    this.lockOff()
    this.ui()
  }

  chooseDuration(event) {
    if (!event.target.checked) return
    this.settings.min = Number(event.target.value)
    this.store.settings = { min: this.settings.min }
    this.saveStore()
    this.total = this.plannedTotal()
  }

  // ── Séance ───────────────────────────────────────────

  start() {
    this.total = this.plannedTotal()
    this.elapsed = 0
    this.phaseP = 0
    this.prepLeft = PREP
    this.prepFrom = this.bD
    this.state = "prep"
    this.lockOn()
    this.ui()
  }

  pause() {
    this.pausedFrom = this.state
    this.state = "paused"
    this.lockOff()
    this.ui()
  }

  resume() {
    this.state = this.pausedFrom || "run"
    this.pausedFrom = null
    this.lockOn()
    this.ui()
  }

  finish() {
    this.state = "done"
    this.elapsed = this.total
    this.phaseP = 1
    this.lockOff()
    const k = todayKey()
    this.store.days[k] = (this.store.days[k] || 0) + 1
    const keys = Object.keys(this.store.days).sort()
    while (keys.length > 30) delete this.store.days[keys.shift()]
    this.saveStore()
    this.renderToday()
    this.ui()
  }

  cycle() { return this.settings.inh + this.settings.exh }
  plannedTotal() { return Math.ceil(this.settings.min * 60 / this.cycle()) * this.cycle() }

  timeline() {
    const c = this.cycle()
    const t = this.elapsed % c
    if (t < this.settings.inh) {
      this.phaseName = "inhale"
      this.phaseP = t / this.settings.inh
      this.bT = ease(this.phaseP)
      this.phaseRemain = this.settings.inh - t
    } else {
      this.phaseName = "exhale"
      this.phaseP = (t - this.settings.inh) / this.settings.exh
      this.bT = 1 - ease(this.phaseP)
      this.phaseRemain = c - t
    }
  }

  // ── Boucle d'animation ───────────────────────────────

  frame(now) {
    let dt = (now - this.last) / 1000
    this.last = now
    if (dt > 0.1) dt = 0.1 // évite un saut si l'onglet a été mis en veille
    this.clock += dt
    this.step(dt)
    this.draw(dt)
    this.rafId = requestAnimationFrame(this.frame)
  }

  step(dt) {
    this.prevBT = this.bT
    if (this.state === "prep") {
      this.prepLeft -= dt
      this.bT = this.prepFrom * (1 - ease(1 - Math.max(this.prepLeft, 0) / PREP))
      if (this.prepLeft <= 0) {
        this.state = "run"
        this.elapsed = 0
        this.timeline()
      }
    } else if (this.state === "run") {
      this.elapsed += dt
      if (this.elapsed >= this.total) {
        this.finish()
        return
      }
      this.timeline()
    } else if (this.state === "idle" || this.state === "done") {
      // Aperçu au repos : respiration lente qui montre l'effet
      const amp = this.reduced ? 0 : (this.state === "done" ? 0.15 : 0.3)
      this.bT = 0.5 + amp * Math.sin(this.clock * Math.PI * 2 / 10)
    }
    // en pause : bT ne bouge plus
  }

  draw(dt) {
    const live = this.state === "run" || this.state === "prep"
    this.bD += (this.bT - this.bD) * (1 - Math.exp(-dt * (live ? 14 : 3)))
    const exhaling = this.bT < this.prevBT - 1e-6
    this.mouth += ((exhaling ? 1 : 0) - this.mouth) * (1 - Math.exp(-dt * 8))
    const L = 1 - this.bD // les cheveux montent quand les poumons se vident

    const r = (120 + 62 * this.bD).toFixed(2)
    this.discCoolTarget.setAttribute("r", r)
    this.discWarmTarget.setAttribute("r", r)
    this.discWarmTarget.style.opacity = this.bD.toFixed(3)

    const showArc = this.state === "run" || (this.state === "paused" && this.pausedFrom === "run")
    this.arcTarget.style.opacity = showArc ? "1" : "0"
    if (showArc) this.arcTarget.style.strokeDashoffset = (ARC * (1 - this.phaseP)).toFixed(1)

    // épaules qui montent à l'inspiration
    this.whoTarget.setAttribute("transform", `translate(0 ${(-5 * this.bD).toFixed(2)})`)
    this.mouthClosedTarget.style.opacity = (1 - this.mouth).toFixed(3)
    this.mouthOpenTarget.style.opacity = this.mouth.toFixed(3)
    this.mouthOpenTarget.setAttribute("ry", (3 + 3 * this.mouth).toFixed(2))

    const wob = this.reduced ? 0 : 1
    for (const l of this.locks) {
      l.Li += (L - l.Li) * (1 - Math.exp(-dt * l.k))
      const a = l.aRest + (l.aLift - l.aRest) * l.Li * l.lf + wob * Math.sin(this.clock * l.fq + l.ph) * (1.5 + 7 * l.Li)
      l.g.setAttribute("transform", `translate(${l.x.toFixed(1)} ${l.y.toFixed(1)}) rotate(${a.toFixed(2)}) scale(1 ${(1 + 0.1 * l.Li).toFixed(3)})`)
    }

    this.drawBubbles(dt, exhaling)
    this.updateText()
  }

  // ── Dessin de Clara ──────────────────────────────────

  rnd() {
    this.seed = (this.seed * 16807) % 2147483647
    return this.seed / 2147483647
  }

  // Des mèches = des groupes de cercles qui pivotent autour de leur racine
  buildHair() {
    // On vide d'abord : au retour arrière, Turbo réaffiche une copie de la page déjà dessinée
    this.hairBackTarget.replaceChildren()
    this.hairFrontTarget.replaceChildren()
    this.locks = []

    // Mèches arrière, réparties autour du crâne
    const NB = 46
    for (let i = 0; i < NB; i++) {
      const th = (-200 + 220 * i / (NB - 1) + (this.rnd() - 0.5) * 4) * Math.PI / 180
      const u = Math.cos(th)
      const v = Math.sin(th)
      this.addLock(this.hairBackTarget, HEAD.cx + HEAD.rx * u, HEAD.cy + HEAD.ry * v,
        -u * 24 + (this.rnd() - 0.5) * 8, liftAngle(u, v),
        92 + 52 * Math.abs(u) + (this.rnd() - 0.5) * 24, 13)
    }
    // Mèches avant, qui encadrent le visage
    const front = [[-164, 12, 116], [-150, 9, 128], [-136, 15, 108], [-16, -12, 116], [-30, -9, 128], [-44, -15, 108]]
    front.forEach(([deg, aRest, len]) => {
      const th = deg * Math.PI / 180
      const u = Math.cos(th)
      const v = Math.sin(th)
      this.addLock(this.hairFrontTarget, HEAD.cx + (HEAD.rx - 3) * u, HEAD.cy + (HEAD.ry - 4) * v, aRest, liftAngle(u, v), len, 11)
    })
  }

  addLock(parent, x, y, aRest, aLift, len, r0) {
    const g = document.createElementNS(NS, "g")
    const n = Math.max(6, Math.round(len / 9))
    const ph = this.rnd() * 6.28
    for (let k = n - 1; k >= 0; k--) {
      const t = k / (n - 1)
      const c = document.createElementNS(NS, "circle")
      c.setAttribute("cx", (Math.sin(k * 1.9 + ph) * 4.5).toFixed(1)) // zigzag = boucles
      c.setAttribute("cy", (t * len).toFixed(1))
      c.setAttribute("r", Math.max(5, r0 - 4.5 * t + (this.rnd() - 0.5) * 2.2).toFixed(1))
      g.appendChild(c)
    }
    parent.appendChild(g)
    this.locks.push({
      g, x, y, aRest, aLift,
      lf: 0.72 + this.rnd() * 0.24, // hauteur max propre à chaque mèche
      k: 2.2 + this.rnd() * 3.4,    // vitesse de réaction : les mèches ne bougent pas toutes ensemble
      Li: 0.5,
      ph: this.rnd() * 6.28,
      fq: 0.7 + this.rnd() * 0.9
    })
  }

  // ── Bulles d'air à l'expiration ──────────────────────

  buildBubbles() {
    this.bubblesTarget.replaceChildren()
    this.bubbles = []
    this.spawnT = 0
    for (let i = 0; i < 14; i++) {
      const c = document.createElementNS(NS, "circle")
      c.setAttribute("class", "breath-bubble")
      c.setAttribute("r", "0")
      c.style.opacity = "0"
      this.bubblesTarget.appendChild(c)
      this.bubbles.push({ el: c, alive: false })
    }
  }

  drawBubbles(dt, exhaling) {
    this.spawnT -= dt
    if (exhaling && !this.reduced && this.spawnT <= 0) {
      this.spawnT = 0.32
      const b = this.bubbles.find((o) => !o.alive)
      if (b) {
        Object.assign(b, {
          alive: true, t: 0, dur: 2.6 + this.rnd() * 1.6,
          x: 200 + (this.rnd() - 0.5) * 230, y: 315 + this.rnd() * 40,
          vy: -(38 + this.rnd() * 30), r: 2 + this.rnd() * 3.5, ph: this.rnd() * 6.28
        })
      }
    }
    for (const b of this.bubbles) {
      if (!b.alive) continue
      b.t += dt
      if (b.t >= b.dur || this.reduced) {
        b.alive = false
        b.el.style.opacity = "0"
        continue
      }
      b.y += b.vy * dt
      const k = b.t / b.dur
      b.el.setAttribute("cx", (b.x + Math.sin(b.t * 2 + b.ph) * 6).toFixed(1))
      b.el.setAttribute("cy", b.y.toFixed(1))
      b.el.setAttribute("r", (b.r * (0.7 + 0.5 * k)).toFixed(2))
      b.el.style.opacity = (Math.sin(Math.PI * k) * 0.9).toFixed(3)
    }
  }

  // ── Textes (mis à jour seulement s'ils changent) ─────

  put(el, key, val) {
    if (this.cache[key] !== val) {
      this.cache[key] = val
      el.textContent = val
    }
  }

  updateText() {
    const c = this.cycle()
    const nCycles = Math.round(this.total / c)
    const running = this.state === "run" || (this.state === "paused" && this.pausedFrom === "run")
    let ph = ""
    let hint = ""
    let cnt = ""
    switch (this.state) {
      case "idle":
        ph = "Installez-vous"
        hint = `${fmtN(this.settings.inh)} s pour inspirer, ${fmtN(this.settings.exh)} s pour expirer`
        break
      case "prep":
        ph = "Videz l’air"
        hint = "doucement, par la bouche"
        cnt = String(Math.max(1, Math.ceil(this.prepLeft)))
        break
      case "run":
        ph = this.phaseName === "inhale" ? "Inspirez" : "Expirez"
        hint = this.phaseName === "inhale" ? "par le nez, le ventre se gonfle" : "par la bouche, sans forcer"
        cnt = String(Math.max(1, Math.ceil(this.phaseRemain - 1e-6)))
        break
      case "paused":
        ph = "En pause"
        hint = "Reprenez quand vous voulez"
        break
      case "done":
        ph = "Séance terminée"
        hint = `${nCycles} respirations en ${fmtT(this.total)}`
        break
    }
    this.put(this.phaseTarget, "ph", ph)
    this.put(this.hintTarget, "hint", hint)
    this.put(this.countTarget, "cnt", cnt)

    const dp = running ? this.phaseName : this.state
    if (this.stageTarget.dataset.phase !== dp) this.stageTarget.dataset.phase = dp

    const prog = this.state === "done" ? 1 : running ? this.elapsed / this.total : 0
    this.barFillTarget.style.width = (prog * 100).toFixed(2) + "%"
    this.put(this.cycleTxtTarget, "ct", running
      ? `Respiration ${Math.min(nCycles, Math.floor(this.elapsed / c) + 1)} sur ${nCycles}`
      : `${nCycles} respirations`)
    this.put(this.timeTxtTarget, "tt", this.state === "done"
      ? "Terminé"
      : "Reste " + fmtT(running ? this.total - this.elapsed : this.total))
  }

  ui() {
    this.primaryTarget.textContent = {
      idle: "Commencer", prep: "Pause", run: "Pause", paused: "Reprendre", done: "Recommencer"
    }[this.state]
    const busy = this.state === "prep" || this.state === "run" || this.state === "paused"
    this.stopTarget.hidden = !busy
    this.settingsTarget.hidden = busy // la durée se choisit avant de commencer
  }

  syncControls() {
    this.durationTargets.forEach((r) => { r.checked = Number(r.value) === this.settings.min })
  }

  renderToday() {
    const n = this.store.days[todayKey()] || 0
    this.dotTargets.forEach((d, i) => d.classList.toggle("is-on", i < n))
    this.todayTxtTarget.textContent = n > 3 ? `${n} séances` : `${n}/3`
    this.todayTarget.setAttribute("aria-label", `${n} séance${n > 1 ? "s" : ""} aujourd’hui sur 3 recommandées`)
  }

  // ── Mémoire locale (reste dans ce navigateur) ────────

  loadStore() {
    try { this.store = JSON.parse(localStorage.getItem(STORE_KEY)) || {} } catch (e) { this.store = {} }
    if (typeof this.store !== "object" || this.store === null) this.store = {}
    if (!this.store.days || typeof this.store.days !== "object") this.store.days = {}
  }

  saveStore() {
    try { localStorage.setItem(STORE_KEY, JSON.stringify(this.store)) } catch (e) { /* stockage indisponible */ }
  }

  // ── Écran allumé pendant la séance (si le navigateur l'autorise) ──

  async lockOn() {
    try {
      if ("wakeLock" in navigator && !this.wakeLock) {
        this.wakeLock = await navigator.wakeLock.request("screen")
        this.wakeLock.addEventListener("release", () => { this.wakeLock = null })
      }
    } catch (e) {
      this.wakeLock = null
    }
  }

  lockOff() {
    try { if (this.wakeLock) this.wakeLock.release() } catch (e) { /* déjà libéré */ }
    this.wakeLock = null
  }
}
