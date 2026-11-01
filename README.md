# CH Polaris

[![CI](https://github.com/pigozard/ch-polaris/actions/workflows/ci.yml/badge.svg)](https://github.com/pigozard/ch-polaris/actions/workflows/ci.yml)

Site web du Centre Hospitalier Polaris — établissement public de psychiatrie adulte, pédopsychiatrique et addictologie.

> Projet personnel : l'établissement, ses unités et ses données sont fictifs. Un bandeau le rappelle en haut de chaque page (`shared/_demo_banner.html.erb`).

## Stack

- **Ruby on Rails 7.1** — backend, routing, modèles
- **PostgreSQL** — base de données
- **Hotwire (Turbo + Stimulus)** — interactions frontend sans SPA
- **Importmap** — gestion des modules JS sans bundler
- **Bootstrap 5 + SCSS (Sprockets)** — styles, avec Font Awesome pour les icônes
- **Simple Form** — formulaires (pages Devise)
- **Action Text** — contenu riche des actualités
- **Active Storage** — fichiers attachés (image de couverture des actualités)
- **Devise** — authentification
- **I18n** — français par défaut (`config/locales/fr.yml`), repli sur l'anglais pour Devise et Simple Form

## Fonctionnalités

### Pages publiques

| Page | URL | Description |
|------|-----|-------------|
| Accueil | `/` | Hero à deux portes d'entrée, chiffres clés |
| Notre établissement | `/hopital` | Offre de soins, pôles, dernières actualités |
| Patients & proches | `/patients` | Hub patients, widget CMP, numéros d'urgence |
| Professionnels | `/professionnels` | Hub professionnels |
| Annuaire | `/annuaire` | Toutes les unités, recherche par nom ou par besoin, filtres et détails |
| Plan | `/carte` | Plan SVG interactif de l'établissement |
| Catalogue ETP | `/etp` | Programmes d'éducation thérapeutique et leurs mois de recrutement |
| Actualités | `/actualites` | Liste et détail des actualités publiées |
| Préparer mon séjour | `/patients/preparer-mon-sejour` | Admission, documents, accès et stationnement par unité |
| Mes droits | `/patients/mes-droits` | Droits des patients et soins sans consentement, sans jargon |
| Outils bien-être | `/patients/outils` | Liste des exercices à faire chez soi |
| Cohérence cardiaque | `/patients/outils/coherence-cardiaque` | Respiration guidée « Respirez avec Clara » |

### Annuaire des unités (`/annuaire`)

L'annuaire sert aussi d'**outil d'orientation**, pour les patients comme pour les professionnels qui adressent un patient.

- Filtrage par pôle (chips colorées), par type et par recherche textuelle
- Panneau latéral au clic : contacts, horaires, règlement visite, secteurs géographiques
- Données JSON embarquées côté serveur, rendu client via Stimulus

**Recherche par nom ou par besoin**

- On peut taper un nom (« Persée »), un type (« cmp », « hôpital de jour ») ou un besoin avec ses propres mots (« bipolaire », « alcool », « maman », « ado »…)
- Chaque fiche trouvée par besoin indique pourquoi elle est proposée : « Proposé pour : Troubles bipolaires »
- Comparaison sans accents ni majuscules, en mots entiers (« père » ne trouve pas « espère ») ou par début de mot pendant la saisie (« accouch » trouve « accouchement »)
- **Sécurité** : toute recherche, quel que soit le mot tapé, affiche un encadré « En cas d'urgence » (15, 3114, urgences psy) annoncé aux lecteurs d'écran
- Aucun diagnostic : c'est la personne qui nomme son besoin, l'annuaire indique seulement où s'adresser

**Dictionnaire des besoins (`config/orientation.yml`)**

13 besoins (troubles bipolaires, dépression, addictions, autisme, périnatalité, enfants, adolescents, psychose, personnes âgées, précarité, traumatisme collectif, proches et aidants, éducation thérapeutique), chacun relié à des unités par leur slug :

```yaml
- libelle: Troubles bipolaires
  mots: [bipolaire, bipolarite, maniaco, maniaco-depressif, humeur]
  unites: [centre-expert-capella, shedar]
```

Ajouter un mot-clé ou un besoin : modifier ce fichier (mots sans accents), puis redémarrer le serveur, car le fichier est lu une seule fois au démarrage. Un test vérifie que chaque slug cité existe bien dans les seeds.

### Widget "Trouver mon CMP" (page patients)

- Choix du public (adultes, enfants, adolescents) et saisie d'un code postal → CMP de secteur via la table `sectors`
- Résultat en Turbo Frame (sans rechargement) : contacts + horaires de consultation

### Catalogue ETP (`/etp`)

- Filtre par pathologie (liens simples, fonctionne sans JavaScript)
- Fiche programme : public, prérequis, durée, mois de recrutement des groupes (« janvier, avril et septembre ») et prochain recrutement calculé à partir de la date du jour, pour que la page ne vieillisse jamais
- Contact de l'UTEP (lu en base) et bouton `mailto:` pré-rempli — aucune donnée stockée sur le site

### Actualités (`/actualites`)

- URL lisible par slug (`/actualites/journee-mondiale-sante-mentale-2025`)
- Seules les actualités publiées sont visibles ; un brouillon renvoie une 404
- Contenu riche via Action Text

### Préparer mon séjour (`/patients/preparer-mon-sejour`)

- Deux parcours d'admission : hospitalisation programmée (bureau des entrées) ou arrivée par les urgences psychiatriques (admission faite sur place)
- Documents et affaires à apporter ; renvoi vers l'annuaire pour le règlement propre à chaque unité
- Tableau stationnement / entrée / accès PMR généré depuis la base (scope `Unit.hospitalization`)

### Mes droits en psychiatrie (`/patients/mes-droits`)

- Questions en langage courant, chacune avec une réponse « En bref »
- Questions dépliables avec `<details>` : fonctionne au clavier et sans JavaScript
- Droits de tout patient, soins sans consentement, contacts (Maison des Usagers lue en base, recours extérieurs)

### Outils bien-être (`/patients/outils`)

Chaque outil est une action de `ToolsController`, avec sa propre vue dans `app/views/tools/`.

**Cohérence cardiaque — « Respirez avec Clara »**

- Rythme 5 s / 5 s (6 respirations par minute), séance de 3, 5 ou 10 minutes, règle 365
- Clara est dessinée en SVG et animée par un controller Stimulus (`breathing_controller.js`) : le disque grandit à l'inspiration, les cheveux flottent et des bulles montent à l'expiration
- Préparation « Videz l'air », pause et reprise, barre d'espace, pause automatique quand l'onglet est masqué, écran maintenu allumé (Wake Lock)
- Compteur de séances du jour stocké dans le `localStorage` : rien n'est envoyé au serveur
- Respecte `prefers-reduced-motion` ; boucle d'animation et écouteurs arrêtés dans `disconnect()` (navigation Turbo)
- CSS isolé sous le préfixe `breath-` / `--b-` pour ne pas entrer en conflit avec le reste du site

Ajouter un outil : une route sous `patients/outils/…`, une action dans `ToolsController`, une vue, une carte dans `tools/index.html.erb` et des tests.

## Organisation du code

| Controller | Rôle |
|------------|------|
| `PagesController` | Pages éditoriales (accueil, hubs, annuaire, plan, séjour, droits) et widget CMP |
| `EtpProgramsController` | Catalogue ETP (`index`, `show`) |
| `NewsController` | Actualités (`index`, `show` par slug) |
| `ToolsController` | Outils bien-être pour les patients |

| Modèle sans table | Rôle |
|-------------------|------|
| `Orientation` | Lit `config/orientation.yml` et fournit à chaque unité ses besoins (`Orientation.needs_for(unit)`), embarqués dans le JSON de l'annuaire |

Toutes les pages publiques sont accessibles sans connexion (`skip_before_action :authenticate_user!`).

Principes d'accessibilité suivis : contrastes AA, liens et boutons utilisables au clavier, filtres en simples liens, `aria-live` pour les contenus qui changent, numéros d'urgence (15, 3114) visibles sur les pages patients.

## Modèles

```
Pole ─┬─ Unit ─┬─ Schedule
      │        ├─ Sector
      │        ├─ UnitRegulation
      │        └─ EtpProgram ── EtpSession
      └─ News (Action Text, Active Storage)
User (Devise)

Orientation (config/orientation.yml, sans table) ── besoins → Unit (par slug)
```

## Évolutions envisagées

- **Chatbot guidé** pour orienter les nouveaux visiteurs, en s'appuyant sur le dictionnaire `config/orientation.yml`
- **Modalités d'adressage** (critères, pièces à joindre, délais) dans le panneau de chaque unité, pour les professionnels

## Installation

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

## Qualité

```bash
bin/rails test           # tests (Minitest)
bundle exec rubocop      # style du code
bundle exec brakeman     # failles de sécurité
```

La CI GitHub (`.github/workflows/ci.yml`) lance ces trois vérifications à chaque push, avec une base PostgreSQL.

Points connus :
- Rails 7.1 n'est plus maintenu : l'alerte Brakeman correspondante est ignorée (`config/brakeman.ignore`) en attendant la montée de version.
- La gem `json` est bloquée sous la version 3, incompatible avec Rails 7.1.
- Le compilateur Sass (`sassc`) ne gère pas les fonctions CSS `min()` / `max()` mélangeant des unités : utiliser `width: 100%` + `max-width` à la place.
