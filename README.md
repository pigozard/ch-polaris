# CH Polaris

Site web du Centre Hospitalier Polaris — établissement public de psychiatrie adulte, pédopsychiatrique et addictologie.

## Stack

- **Ruby on Rails 7.1** — backend, routing, modèles
- **PostgreSQL** — base de données
- **Hotwire (Turbo + Stimulus)** — interactions frontend sans SPA
- **Importmap** — gestion des modules JS sans bundler
- **Devise** — authentification

## Fonctionnalités

### Pages publiques

| Page | URL | Description |
|------|-----|-------------|
| Accueil | `/` | Hero, chiffres clés, actualités |
| Notre établissement | `/hopital` | Offre de soins, pôles, actualités |
| Patients & proches | `/patients` | Orientation, droits, widget CMP |
| Professionnels | `/professionnels` | Annuaire, ETP, adressage |
| Annuaire | `/annuaire` | Toutes les unités, filtrables et avec détails |
| Plan | `/carte` | Plan SVG interactif de l'établissement |

### Annuaire des unités (`/annuaire`)

- Filtrage par pôle (chips colorées), par type et par recherche textuelle
- Panneau latéral au clic : contacts, horaires, règlement visite, secteurs géographiques
- Données JSON embarquées côté serveur, rendu client via Stimulus

### Widget "Trouver mon CMP" (page patients)

- Saisie d'un code postal → recherche du CMP de secteur via la table `sectors`
- Résultat en Turbo Frame (sans rechargement) : contacts + horaires de consultation

## Modèles

```
Pole → Unit → Schedule
                    → Sector
                    → UnitRegulation
                    → EtpProgram → EtpSession
     → News
User (Devise)
```

## Installation

```bash
bundle install
rails db:create db:migrate db:seed
bin/rails server
```

## Tests

```bash
bin/rails test
```

13 tests couvrant le modèle `Unit` et le controller `PagesController`.
