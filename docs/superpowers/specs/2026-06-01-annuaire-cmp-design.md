# Design : Annuaire des unités + Recherche CMP

**Date :** 2026-06-01  
**Périmètre :** Feature "semaine 1" (annuaire) + "semaine 2" (sectorisation CMP)

---

## 1. Annuaire des unités (`/annuaire`)

### Objectif

Permettre à toute personne (patient, proche, professionnel) de trouver rapidement une unité du CH Polaris, d'en voir les coordonnées et les informations pratiques sans quitter la page.

### Route & controller

- Nouvelle route : `get "annuaire", to: "pages#annuaire"`
- Action `PagesController#annuaire` : charge `@poles = Pole.ordered.includes(units: [:schedules, :sectors, :unit_regulation])`
- Onglet ajouté dans `_navbar.html.erb`

### Structure de la page

**Barre de filtres**
- Chips pôles : une chip par pôle, colorée avec `pole.color`, filtre par `pole.slug`
- Dropdown type : liste des `Unit::UNIT_TYPES` traduits en français
- Champ texte de recherche libre (nom d'unité)

**Grille de cartes**
- Une carte par unité : nom, badge type, couleur du pôle, téléphone
- Responsive : 3 colonnes desktop, 2 tablet, 1 mobile
- Filtrée dynamiquement côté client (Stimulus)

**Panneau latéral (side panel)**
- Déclenché au clic sur une carte
- Contenu : nom, type traduit, pôle (couleur), description, téléphone, email, PMR, adresse, parking
- Section horaires (`schedules`) : consultation / visite / téléphone
- Section secteurs géographiques (`sectors`) : liste des communes couvertes
- Section règlement visite (`unit_regulation`) si présent : visiteurs max, objets autorisés/interdits, accès
- Bouton de fermeture, overlay sur mobile

### Implémentation JS

Pattern identique à `carte.html.erb` :
- Données embarquées en JSON dans un attribut `data-units` sur le wrapper
- Stimulus controller `annuaire_controller.js` : gère filtres, rendu cartes, toggle panel
- Aucune requête réseau supplémentaire après le chargement initial

### Mise à jour page professionnels

La carte hub "Annuaire des unités" (actuellement `hub-card--soon`) devient un lien live vers `/annuaire`.

La carte hub "Annuaire des unités" dans la page patients devient également un lien live vers `/annuaire`.

---

## 2. Widget "Trouver mon CMP" (page patients)

### Objectif

Permettre à un patient ou proche de trouver son CMP de secteur en saisissant simplement son code postal.

### Comportement

1. L'utilisateur saisit un code postal (5 chiffres)
2. Requête `GET /patients/trouver-mon-cmp?postal_code=XXXXX`
3. Recherche dans `Sector` : `where(postal_code: params[:postal_code])` → unité(s) de type `cmp`
4. Rendu partiel Turbo Frame avec le résultat :
   - **Trouvé (1 CMP)** : nom, téléphone, email, horaires de consultation
   - **Trouvé (plusieurs CMP)** : liste des résultats (cas de secteurs découpés par rue)
   - **Non trouvé** : message d'orientation vers le standard (téléphone général)
5. Si le code postal ne correspond à aucun secteur connu, message d'erreur clair

### Route & controller

- Nouvelle route : `get "patients/trouver-mon-cmp", to: "pages#trouver_mon_cmp"`
- Action `PagesController#trouver_mon_cmp` :
  - Valide le format du code postal (5 chiffres)
  - Cherche les unités CMP via `Sector.where(postal_code: params[:postal_code]).includes(:unit)`
  - Filtre `unit.unit_type == "cmp"`
  - Renvoie le partial `pages/_cmp_result.html.erb` dans un Turbo Frame

### UI dans la page patients

La carte hub "Trouver mon CMP" (actuellement `hub-card--soon`) est remplacée par :
- Un champ code postal + bouton "Rechercher"
- Un `<turbo-frame id="cmp-result">` pour afficher le résultat inline
- Validation HTML5 (`pattern="[0-9]{5}"`)

---

## 3. Traductions unit_type

Les `unit_type` de `Unit::UNIT_TYPES` nécessitent une table de traduction française pour l'affichage dans l'annuaire et le panneau latéral. Implémentée comme helper ou constante dans le modèle `Unit`.

Exemples : `ward_open` → "Hospitalisation ouverte", `cmp` → "Centre Médico-Psychologique", `hdj` → "Hôpital de jour", etc.

---

## 4. Ce qui n'est PAS dans ce périmètre

- Page dédiée `/unites/:slug` (pas de navigation vers page unité)
- Admin CRUD (géré séparément)
- Filtrage CMP par rue (le champ `street_pattern` existe mais non exploité ici)
- Catalogue ETP dans l'annuaire
