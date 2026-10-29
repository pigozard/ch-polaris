# CH Polaris

[![CI](https://github.com/pigozard/ch-polaris/actions/workflows/ci.yml/badge.svg)](https://github.com/pigozard/ch-polaris/actions/workflows/ci.yml)

Site web du Centre Hospitalier Polaris — établissement public de psychiatrie adulte, pédopsychiatrique et addictologie.

> Projet personnel : l'établissement, ses unités et ses données sont fictifs.

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
| Annuaire | `/annuaire` | Toutes les unités, filtrables et avec détails |
| Plan | `/carte` | Plan SVG interactif de l'établissement |
| Catalogue ETP | `/etp` | Programmes d'éducation thérapeutique et leurs sessions |
| Actualités | `/actualites` | Liste et détail des actualités publiées |
| Préparer mon séjour | `/patients/preparer-mon-sejour` | Admission, documents, accès et stationnement par unité |
| Mes droits | `/patients/mes-droits` | Droits des patients et soins sans consentement, sans jargon |

### Annuaire des unités (`/annuaire`)

- Filtrage par pôle (chips colorées), par type et par recherche textuelle
- Panneau latéral au clic : contacts, horaires, règlement visite, secteurs géographiques
- Données JSON embarquées côté serveur, rendu client via Stimulus

### Widget "Trouver mon CMP" (page patients)

- Choix du public (adultes, enfants, adolescents) et saisie d'un code postal → CMP de secteur via la table `sectors`
- Résultat en Turbo Frame (sans rechargement) : contacts + horaires de consultation

### Catalogue ETP (`/etp`)

- Filtre par pathologie (liens simples, fonctionne sans JavaScript)
- Fiche programme : public, prérequis, durée, sessions avec statut et places restantes
- Contact de l'UTEP (lu en base) et bouton `mailto:` pré-rempli — aucune donnée stockée sur le site

### Actualités (`/actualites`)

- URL lisible par slug (`/actualites/journee-mondiale-sante-mentale-2025`)
- Seules les actualités publiées sont visibles ; un brouillon renvoie une 404
- Contenu riche via Action Text

## Modèles

```
Pole ─┬─ Unit ─┬─ Schedule
      │        ├─ Sector
      │        ├─ UnitRegulation
      │        └─ EtpProgram ── EtpSession
      └─ News (Action Text, Active Storage)
User (Devise)
```

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
