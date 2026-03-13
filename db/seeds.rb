puts "🧹 Cleaning database..."
News.destroy_all
EtpSession.destroy_all
EtpProgram.destroy_all
UnitRegulation.destroy_all
Sector.destroy_all
Schedule.destroy_all
Unit.destroy_all
Pole.destroy_all

puts "⭐ Creating poles..."

cassiopee = Pole.create!(
  name: "Pôle Cassiopée",
  slug: "cassiopee",
  description: "Le Pôle Cassiopée assure la prise en charge psychiatrique des adultes du secteur nord du territoire de Novapolis. Il regroupe les unités d'hospitalisation, le CMP de secteur et les structures ambulatoires de proximité.",
  color: "#3B82F6",
  position: 1,
  transversal: false
)

orion = Pole.create!(
  name: "Pôle Orion",
  slug: "orion",
  description: "Le Pôle Orion couvre le secteur sud du territoire. Il propose une offre complète de soins psychiatriques adultes, de l'hospitalisation complète aux soins ambulatoires, en passant par l'hôpital de jour.",
  color: "#8B5CF6",
  position: 2,
  transversal: false
)

lyra = Pole.create!(
  name: "Pôle Lyra",
  slug: "lyra",
  description: "Le Pôle Lyra est dédié aux prises en charge spécialisées : addictologie, réhabilitation psychosociale et troubles sévères et persistants. Il accueille des patients adultes orientés par les équipes de secteur.",
  color: "#F97316",
  position: 3,
  transversal: false
)

pleiades = Pole.create!(
  name: "Pôle Pléiades",
  slug: "pleiades",
  description: "Le Pôle Pléiades assure la prise en charge psychiatrique des enfants et adolescents de 0 à 18 ans sur l'ensemble du territoire. Il dispose de structures d'hospitalisation, d'hôpitaux de jour et de CMP dédiés.",
  color: "#22C55E",
  position: 4,
  transversal: false
)

polaris_pole = Pole.create!(
  name: "Pôle Polaris",
  slug: "polaris-transversal",
  description: "Le Pôle Polaris regroupe les structures transversales de l'établissement : CUMP, centres experts, UTEP, Maison des Usagers et équipes mobiles. Il intervient en appui et en ressource pour l'ensemble des pôles.",
  color: "#94A3B8",
  position: 5,
  transversal: true
)

puts "🏥 Creating units..."

# ── PÔLE CASSIOPÉE ──────────────────────────────────────
andromede = Unit.create!(
  pole: cassiopee,
  name: "Unité Andromède",
  slug: "andromede",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 01 10 01",
  email: "andromede@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte accueillant des adultes en soins libres. L'équipe pluridisciplinaire propose un accompagnement individualisé orienté vers le rétablissement.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-andromede",
  position: 1
)

Unit.create!(
  pole: cassiopee,
  name: "Unité Persée",
  slug: "persee",
  unit_type: "ward_closed",
  capacity: 15,
  phone: "05 99 01 10 02",
  email: "persee@ch-polaris.fr",
  description: "Unité d'hospitalisation complète fermée accueillant des adultes en soins sans consentement et en situation de crise aiguë. Cadre sécurisé et soins intensifs.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-persee",
  position: 2
)

cmp_cassiopee = Unit.create!(
  pole: cassiopee,
  name: "CMP Cassiopée",
  slug: "cmp-cassiopee",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 01 10 03",
  email: "cmp.cassiopee@ch-polaris.fr",
  description: "Centre Médico-Psychologique du secteur nord. Lieu pivot du soin ambulatoire, il assure les consultations psychiatriques, le suivi infirmier et l'orientation vers les structures adaptées.",
  address: "45 avenue de la Nébuleuse, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Stationnement en voirie — zone bleue",
  svg_zone_id: "zone-cmp-cassiopee",
  position: 3
)

Unit.create!(
  pole: cassiopee,
  name: "HDJ Céphée",
  slug: "hdj-cephee",
  unit_type: "hdj",
  capacity: 15,
  phone: "05 99 01 10 04",
  email: "hdj.cephee@ch-polaris.fr",
  description: "Hôpital de Jour proposant des soins à temps partiel pour les adultes du secteur nord. Activités thérapeutiques groupales, ateliers de réhabilitation et suivi médical.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-hdj-cephee",
  position: 4
)

Unit.create!(
  pole: cassiopee,
  name: "CATTP Pégase",
  slug: "cattp-pegase",
  unit_type: "cattp",
  capacity: nil,
  phone: "05 99 01 10 05",
  email: "cattp.pegase@ch-polaris.fr",
  description: "Centre d'Accueil Thérapeutique à Temps Partiel proposant des activités de soutien et de socialisation pour les patients stabilisés du secteur nord.",
  address: "8 rue de la Voie Lactée, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking municipal à 200m",
  svg_zone_id: "zone-cattp-pegase",
  position: 5
)

# ── PÔLE ORION ──────────────────────────────────────────
Unit.create!(
  pole: orion,
  name: "Unité Bételgeuse",
  slug: "betelgeuse",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 02 10 01",
  email: "betelgeuse@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte du secteur sud. Accueil en soins libres, projet thérapeutique individualisé et préparation active de la sortie.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-betelgeuse",
  position: 1
)

Unit.create!(
  pole: orion,
  name: "Unité Rigel",
  slug: "rigel",
  unit_type: "ward_closed",
  capacity: 15,
  phone: "05 99 02 10 02",
  email: "rigel@ch-polaris.fr",
  description: "Unité d'hospitalisation complète fermée du secteur sud. Prise en charge des situations de crise et des soins sans consentement.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-rigel",
  position: 2
)

cmp_orion = Unit.create!(
  pole: orion,
  name: "CMP Orion",
  slug: "cmp-orion",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 02 10 03",
  email: "cmp.orion@ch-polaris.fr",
  description: "Centre Médico-Psychologique du secteur sud. Consultations psychiatriques et suivi ambulatoire pour les adultes résidant dans le secteur sud de Novapolis.",
  address: "3 boulevard des Étoiles, 33998 Novapolis-Sud",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-cmp-orion",
  position: 3
)

Unit.create!(
  pole: orion,
  name: "HDJ Bellatrix",
  slug: "hdj-bellatrix",
  unit_type: "hdj",
  capacity: 15,
  phone: "05 99 02 10 04",
  email: "hdj.bellatrix@ch-polaris.fr",
  description: "Hôpital de Jour du secteur sud. Soins à temps partiel, ateliers thérapeutiques et accompagnement vers l'autonomie.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-hdj-bellatrix",
  position: 4
)

Unit.create!(
  pole: orion,
  name: "CATTP Mintaka",
  slug: "cattp-mintaka",
  unit_type: "cattp",
  capacity: nil,
  phone: "05 99 02 10 05",
  email: "cattp.mintaka@ch-polaris.fr",
  description: "Centre d'Accueil Thérapeutique à Temps Partiel du secteur sud. Activités groupales et soutien à la réinsertion sociale.",
  address: "17 rue du Méridien, 33998 Novapolis-Sud",
  pmr_accessible: true,
  parking_info: "Stationnement en voirie",
  svg_zone_id: "zone-cattp-mintaka",
  position: 5
)

# ── PÔLE LYRA ───────────────────────────────────────────
Unit.create!(
  pole: lyra,
  name: "Unité Véga",
  slug: "vega",
  unit_type: "ward_open",
  capacity: 18,
  phone: "05 99 03 10 01",
  email: "vega@ch-polaris.fr",
  description: "Unité de réhabilitation psychosociale en hospitalisation complète ouverte. Programme structuré visant le rétablissement et la réinsertion socioprofessionnelle.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-vega",
  position: 1
)

Unit.create!(
  pole: lyra,
  name: "Unité Altaïr",
  slug: "altair",
  unit_type: "ward_closed",
  capacity: 12,
  phone: "05 99 03 10 02",
  email: "altair@ch-polaris.fr",
  description: "Unité d'addictologie en hospitalisation complète. Sevrages complexes, comorbidités psychiatriques et élaboration du projet thérapeutique.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-altair",
  position: 2
)

cmp_lyra = Unit.create!(
  pole: lyra,
  name: "CMP Lyra",
  slug: "cmp-lyra",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 03 10 03",
  email: "cmp.lyra@ch-polaris.fr",
  description: "CMP spécialisé en addictologie. Consultations de suivi post-sevrage, accompagnement thérapeutique et orientation vers les dispositifs de réduction des risques.",
  address: "22 rue de la Lyre, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking municipal à 100m",
  svg_zone_id: "zone-cmp-lyra",
  position: 3
)

Unit.create!(
  pole: lyra,
  name: "HDJ Deneb",
  slug: "hdj-deneb",
  unit_type: "hdj",
  capacity: 12,
  phone: "05 99 03 10 04",
  email: "hdj.deneb@ch-polaris.fr",
  description: "Hôpital de Jour de réhabilitation psychosociale. Programme intensif d'ateliers thérapeutiques, remédiation cognitive et entraînement aux habiletés sociales.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-hdj-deneb",
  position: 4
)

Unit.create!(
  pole: lyra,
  name: "CATTP Alcor",
  slug: "cattp-alcor",
  unit_type: "cattp",
  capacity: nil,
  phone: "05 99 03 10 05",
  email: "cattp.alcor@ch-polaris.fr",
  description: "CATTP spécialisé en addictologie. Groupes de parole, prévention de la rechute et soutien à l'abstinence.",
  address: "22 rue de la Lyre, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Stationnement en voirie",
  svg_zone_id: "zone-cattp-alcor",
  position: 5
)

# ── PÔLE PLÉIADES ────────────────────────────────────────
Unit.create!(
  pole: pleiades,
  name: "Unité Maia",
  slug: "maia",
  unit_type: "ward_open",
  capacity: 10,
  phone: "05 99 04 10 01",
  email: "maia@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte pour adolescents (12-18 ans). Soins libres, scolarisation maintenue et accompagnement familial.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P3 — accès par l'entrée pédiatrique",
  svg_zone_id: "zone-maia",
  position: 1
)

Unit.create!(
  pole: pleiades,
  name: "Unité Alcyone",
  slug: "alcyone",
  unit_type: "ward_closed",
  capacity: 8,
  phone: "05 99 04 10 02",
  email: "alcyone@ch-polaris.fr",
  description: "Unité d'hospitalisation complète fermée pour adolescents. Accueil en situation de crise, soins sans consentement et évaluations diagnostiques.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P3 — accès par l'entrée pédiatrique",
  svg_zone_id: "zone-alcyone",
  position: 2
)

Unit.create!(
  pole: pleiades,
  name: "CMP Pléiades",
  slug: "cmp-pleiades",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 04 10 03",
  email: "cmp.pleiades@ch-polaris.fr",
  description: "CMP de pédopsychiatrie pour enfants de 0 à 11 ans. Consultations diagnostiques, bilans développementaux et suivis thérapeutiques.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-cmp-pleiades",
  position: 3
)

Unit.create!(
  pole: pleiades,
  name: "CMP Électre",
  slug: "cmp-electre",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 04 10 04",
  email: "cmp.electre@ch-polaris.fr",
  description: "CMP dédié aux adolescents de 12 à 18 ans. Consultations psychiatriques, suivis psychologiques et groupes thérapeutiques.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-cmp-electre",
  position: 4
)

Unit.create!(
  pole: pleiades,
  name: "HDJ Méropé",
  slug: "hdj-merope",
  unit_type: "hdj",
  capacity: 10,
  phone: "05 99 04 10 05",
  email: "hdj.merope@ch-polaris.fr",
  description: "Hôpital de Jour pour enfants de 6 à 12 ans. Soins intensifs à temps partiel, ateliers thérapeutiques et soutien aux apprentissages.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P3 — accès par l'entrée pédiatrique",
  svg_zone_id: "zone-hdj-merope",
  position: 5
)

Unit.create!(
  pole: pleiades,
  name: "HDJ Taygète",
  slug: "hdj-taygete",
  unit_type: "hdj",
  capacity: 10,
  phone: "05 99 04 10 06",
  email: "hdj.taygete@ch-polaris.fr",
  description: "Hôpital de Jour pour adolescents de 12 à 18 ans. Programme thérapeutique structuré, groupes de pairs et préparation à l'autonomie.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P3 — accès par l'entrée pédiatrique",
  svg_zone_id: "zone-hdj-taygete",
  position: 6
)

Unit.create!(
  pole: pleiades,
  name: "CATTP Astérope",
  slug: "cattp-asterope",
  unit_type: "cattp",
  capacity: nil,
  phone: "05 99 04 10 07",
  email: "cattp.asterope@ch-polaris.fr",
  description: "CATTP adolescents. Activités thérapeutiques groupales et soutien à la socialisation.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-cattp-asterope",
  position: 7
)

Unit.create!(
  pole: pleiades,
  name: "SESSAD Célène",
  slug: "sessad-celene",
  unit_type: "sessad",
  capacity: nil,
  phone: "05 99 04 10 08",
  email: "sessad.celene@ch-polaris.fr",
  description: "Service d'Éducation Spéciale et de Soins À Domicile. Accompagnement des enfants et adolescents présentant des troubles psychiques dans leur milieu de vie.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-sessad-celene",
  position: 8
)

# ── PÔLE POLARIS (TRANSVERSAL) ───────────────────────────
Unit.create!(
  pole: polaris_pole,
  name: "CUMP Polaris",
  slug: "cump-polaris",
  unit_type: "cump",
  capacity: nil,
  phone: "05 99 05 10 01",
  email: "cump@ch-polaris.fr",
  description: "Cellule d'Urgence Médico-Psychologique. Intervient lors d'événements traumatiques collectifs pour assurer le soutien psychologique immédiat des victimes et des professionnels.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-cump",
  position: 1
)

Unit.create!(
  pole: polaris_pole,
  name: "Centre Expert Sirius",
  slug: "centre-expert-sirius",
  unit_type: "expert_center",
  capacity: nil,
  phone: "05 99 05 10 02",
  email: "sirius@ch-polaris.fr",
  description: "Centre Expert en dépression résistante. Évaluation et prise en charge des patients en échec thérapeutique, proposant des protocoles spécialisés.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-sirius",
  position: 2
)

Unit.create!(
  pole: polaris_pole,
  name: "Centre Expert Arcturus",
  slug: "centre-expert-arcturus",
  unit_type: "expert_center",
  capacity: nil,
  phone: "05 99 05 10 03",
  email: "arcturus@ch-polaris.fr",
  description: "Centre Expert Autisme Adulte. Bilans diagnostiques, accompagnement thérapeutique et soutien à l'inclusion professionnelle des personnes autistes adultes.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-arcturus",
  position: 3
)

Unit.create!(
  pole: polaris_pole,
  name: "Centre Expert Capella",
  slug: "centre-expert-capella",
  unit_type: "expert_center",
  capacity: nil,
  phone: "05 99 05 10 04",
  email: "capella@ch-polaris.fr",
  description: "Centre Expert Troubles Bipolaires. Éducation thérapeutique, prévention des rechutes et optimisation du traitement de stabilisation de l'humeur.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-capella",
  position: 4
)

utep = Unit.create!(
  pole: polaris_pole,
  name: "UTEP Étoile Polaire",
  slug: "utep-etoile-polaire",
  unit_type: "utep",
  capacity: nil,
  phone: "05 99 05 10 05",
  email: "utep@ch-polaris.fr",
  description: "Unité Transversale d'Éducation du Patient. Coordonne et développe les programmes d'éducation thérapeutique pour l'ensemble de l'établissement.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-utep",
  position: 5
)

Unit.create!(
  pole: polaris_pole,
  name: "La Maison Boussole",
  slug: "maison-boussole",
  unit_type: "users_house",
  capacity: nil,
  phone: "05 99 05 10 06",
  email: "boussole@ch-polaris.fr",
  description: "Maison des Usagers ouverte à tous les patients, familles et proches. Espace d'information, d'écoute et de soutien, animé par des associations de patients et de familles.",
  address: "1 place de l'Étoile, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-boussole",
  position: 6
)

Unit.create!(
  pole: polaris_pole,
  name: "EMPP Lumière",
  slug: "empp-lumiere",
  unit_type: "empp",
  capacity: nil,
  phone: "05 99 05 10 07",
  email: "empp.lumiere@ch-polaris.fr",
  description: "Équipe Mobile Psychiatrie Précarité. Intervient auprès des personnes en situation de précarité présentant des troubles psychiques, en lien avec les acteurs sociaux du territoire.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-empp-lumiere",
  position: 7
)

Unit.create!(
  pole: polaris_pole,
  name: "EMPP Aurore",
  slug: "empp-aurore",
  unit_type: "empp",
  capacity: nil,
  phone: "05 99 05 10 08",
  email: "empp.aurore@ch-polaris.fr",
  description: "Équipe Mobile Psychiatrie Personne Âgée. Évaluations et interventions à domicile ou en EHPAD pour les personnes âgées présentant des troubles psychiques.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-empp-aurore",
  position: 8
)

Unit.create!(
  pole: polaris_pole,
  name: "ULPSY Polaris",
  slug: "ulpsy-polaris",
  unit_type: "ulpsy",
  capacity: nil,
  phone: "05 99 05 10 09",
  email: "ulpsy@ch-polaris.fr",
  description: "Unité de Liaison Psychiatrique. Intervient dans les services de médecine et chirurgie du territoire pour les patients présentant des comorbidités psychiatriques.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-ulpsy",
  position: 9
)

Unit.create!(
  pole: polaris_pole,
  name: "Unité Polaris Longue Durée",
  slug: "polaris-longue-duree",
  unit_type: "long_stay",
  capacity: 24,
  phone: "05 99 05 10 10",
  email: "longue-duree@ch-polaris.fr",
  description: "Unité de soins de longue durée pour patients nécessitant une prise en charge psychiatrique au long cours dans un cadre hospitalier.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-longue-duree",
  position: 10
)

puts "🕐 Creating schedules..."

# CMP Cassiopée
Schedule.create!(unit: cmp_cassiopee, schedule_type: "consultation", opens_at: "08:30", closes_at: "17:30", note: "Sur rendez-vous uniquement")
Schedule.create!(unit: cmp_cassiopee, schedule_type: "phone", opens_at: "09:00", closes_at: "12:00", note: "Accueil téléphonique du lundi au vendredi")

# CMP Orion
Schedule.create!(unit: cmp_orion, schedule_type: "consultation", opens_at: "09:00", closes_at: "18:00", note: "Sur rendez-vous — urgences évaluées le matin")
Schedule.create!(unit: cmp_orion, schedule_type: "phone", opens_at: "09:00", closes_at: "12:00", note: nil)

# CMP Lyra
Schedule.create!(unit: cmp_lyra, schedule_type: "consultation", opens_at: "09:00", closes_at: "17:00", note: "Sur adressage médical")
Schedule.create!(unit: cmp_lyra, schedule_type: "phone", opens_at: "09:00", closes_at: "11:30", note: nil)

# Unité Andromède — horaires de visite
Schedule.create!(unit: andromede, schedule_type: "visiting", opens_at: "14:00", closes_at: "19:00", note: "2 visiteurs maximum par patient")

puts "📍 Creating sectors..."

# Secteur CMP Cassiopée — nord de Novapolis
[
  { postal_code: "33999", city: "Novapolis", street_pattern: nil },
  { postal_code: "33997", city: "Novapolis-Nord", street_pattern: nil },
  { postal_code: "33996", city: "Saint-Astre", street_pattern: nil }
].each do |s|
  Sector.create!(unit: cmp_cassiopee, **s)
end

# Secteur CMP Orion — sud de Novapolis
[
  { postal_code: "33998", city: "Novapolis-Sud", street_pattern: nil },
  { postal_code: "33995", city: "Belvédère", street_pattern: nil },
  { postal_code: "33999", city: "Novapolis", street_pattern: "Rue du Méridien, Avenue des Galaxies, Boulevard du Cosmos" }
].each do |s|
  Sector.create!(unit: cmp_orion, **s)
end

puts "📋 Creating unit regulations..."

UnitRegulation.create!(
  unit: andromede,
  max_visitors: 2,
  forbidden_items: ["téléphone portable", "ordinateur", "alcool", "médicaments personnels non validés", "objets tranchants"].to_json,
  allowed_items: ["livres", "vêtements personnels", "photos de proches", "jeux de société"].to_json,
  visiting_notes: "Les visites ont lieu tous les jours de 14h à 19h. Les mineurs de moins de 12 ans ne sont pas admis sans accord médical préalable. Merci de vous présenter à l'accueil de l'unité.",
  access_info: "Accès PMR par l'entrée principale. Ascenseur disponible. Interphone à l'entrée de l'unité."
)

UnitRegulation.create!(
  unit: Unit.find_by(slug: "persee"),
  max_visitors: 2,
  forbidden_items: ["téléphone portable", "ordinateur", "alcool", "médicaments personnels", "objets tranchants", "cordons et lacets", "briquet"].to_json,
  allowed_items: ["livres", "vêtements personnels sans cordon", "photos de proches"].to_json,
  visiting_notes: "Les visites sont soumises à autorisation médicale préalable. Horaires sur prescription. Fouille des effets personnels à l'entrée.",
  access_info: "Accès PMR disponible. Interphone sécurisé. Sas d'entrée obligatoire."
)

puts "🎓 Creating ETP programs..."

prog_bipolaire = EtpProgram.create!(
  unit: utep,
  name: "Vivre avec un trouble bipolaire",
  description: "Programme d'éducation thérapeutique destiné aux personnes diagnostiquées avec un trouble bipolaire. Il vise à améliorer la connaissance de la maladie, la reconnaissance des signes précurseurs et la gestion du traitement.",
  target_audience: "Patients adultes diagnostiqués trouble bipolaire, stabilisés",
  pathology: "bipolar",
  prerequisites: "Diagnostic posé par un psychiatre. Être en phase de stabilisation. Entretien individuel préalable avec une infirmière de l'UTEP.",
  duration: "8 séances de 2h",
  modality: "group"
)

prog_depression = EtpProgram.create!(
  unit: utep,
  name: "Comprendre et agir sur ma dépression",
  description: "Programme destiné aux personnes souffrant de dépression récurrente. Il aborde la compréhension des mécanismes dépressifs, la gestion du traitement antidépresseur et les stratégies de prévention des rechutes.",
  target_audience: "Patients adultes avec dépression récurrente ou résistante",
  pathology: "depression",
  prerequisites: "Suivi psychiatrique en cours. Au moins un épisode dépressif traité. Entretien préalable avec l'UTEP.",
  duration: "6 séances de 2h",
  modality: "group"
)

prog_addiction = EtpProgram.create!(
  unit: utep,
  name: "Mon parcours de soins en addictologie",
  description: "Programme transversal pour les patients engagés dans un parcours de soins en addictologie. Aborde la compréhension des mécanismes de dépendance, la prévention de la rechute et la construction du projet de vie.",
  target_audience: "Patients adultes en suivi addictologique",
  pathology: "addiction",
  prerequisites: "Être suivi au CMP Lyra ou en HDJ Deneb. Motivation exprimée lors d'un entretien infirmier.",
  duration: "5 séances de 2h30",
  modality: "mixed"
)

prog_anxiete = EtpProgram.create!(
  unit: utep,
  name: "Apprivoiser mon anxiété",
  description: "Programme destiné aux personnes souffrant de troubles anxieux. Techniques de gestion du stress, psychoéducation sur les mécanismes anxieux et outils de régulation émotionnelle.",
  target_audience: "Patients adultes avec troubles anxieux",
  pathology: "anxiety",
  prerequisites: "Diagnostic établi. Suivi en cours. Entretien individuel préalable.",
  duration: "6 séances de 1h30",
  modality: "group"
)

puts "📅 Creating ETP sessions..."

# Sessions bipolaire
EtpSession.create!(
  etp_program: prog_bipolaire,
  session_type: "recurring",
  recurrence: "Tous les mardis de 14h à 16h",
  max_participants: 8,
  current_participants: 6,
  location: "Salle Étoile — UTEP, Bâtiment principal",
  status: "open",
  registration_info: "Inscription sur entretien infirmier. Contacter l'UTEP au 05 99 05 10 05."
)

EtpSession.create!(
  etp_program: prog_bipolaire,
  session_type: "punctual",
  starts_on: Date.today + 45,
  ends_on: Date.today + 45 + 56,
  max_participants: 8,
  current_participants: 2,
  location: "Salle Étoile — UTEP, Bâtiment principal",
  status: "open",
  registration_info: "Inscription avant le #{(Date.today + 30).strftime('%d/%m/%Y')}. Contacter l'UTEP au 05 99 05 10 05."
)

# Sessions dépression
EtpSession.create!(
  etp_program: prog_depression,
  session_type: "recurring",
  recurrence: "Tous les jeudis de 10h à 12h",
  max_participants: 8,
  current_participants: 8,
  location: "Salle Nébuleuse — UTEP, Bâtiment principal",
  status: "full",
  registration_info: "Groupe complet. Inscription sur liste d'attente au 05 99 05 10 05."
)

EtpSession.create!(
  etp_program: prog_depression,
  session_type: "punctual",
  starts_on: Date.today + 30,
  ends_on: Date.today + 30 + 42,
  max_participants: 8,
  current_participants: 3,
  location: "Salle Nébuleuse — UTEP, Bâtiment principal",
  status: "open",
  registration_info: "Inscription avant le #{(Date.today + 15).strftime('%d/%m/%Y')}. Contacter l'UTEP."
)

# Sessions addiction
EtpSession.create!(
  etp_program: prog_addiction,
  session_type: "recurring",
  recurrence: "Tous les mercredis de 9h à 11h30",
  max_participants: 6,
  current_participants: 4,
  location: "Salle Lyra — CMP Lyra",
  status: "open",
  registration_info: "Sur orientation du CMP Lyra ou HDJ Deneb uniquement."
)

# Sessions anxiété
EtpSession.create!(
  etp_program: prog_anxiete,
  session_type: "punctual",
  starts_on: Date.today + 60,
  ends_on: Date.today + 60 + 35,
  max_participants: 10,
  current_participants: 1,
  location: "Salle Étoile — UTEP, Bâtiment principal",
  status: "open",
  registration_info: "Nouvelle session. Inscriptions ouvertes. Contacter l'UTEP au 05 99 05 10 05."
)

puts "📰 Creating news..."

News.create!(
  pole: nil,
  title: "Journée Mondiale de la Santé Mentale 2025",
  slug: "journee-mondiale-sante-mentale-2025",
  summary: "Le CH Polaris vous invite à participer aux événements organisés à l'occasion de la Journée Mondiale de la Santé Mentale le 10 octobre.",
  category: "health_day",
  published_at: Date.today - 10,
  published: true
)

News.create!(
  pole: polaris_pole,
  title: "Ouverture d'un nouveau groupe ETP bipolaire",
  slug: "nouveau-groupe-etp-bipolaire",
  summary: "L'UTEP Étoile Polaire ouvre un nouveau groupe d'éducation thérapeutique dédié aux troubles bipolaires à partir du mois prochain.",
  category: "announcement",
  published_at: Date.today - 5,
  published: true
)

News.create!(
  pole: cassiopee,
  title: "Le Pôle Cassiopée reçoit la certification HAS",
  slug: "pole-cassiopee-certification-has",
  summary: "Le Pôle Cassiopée a obtenu la certification de la Haute Autorité de Santé avec mention, saluant la qualité de sa prise en charge et l'implication de ses équipes.",
  category: "institutional",
  published_at: Date.today - 2,
  published: true
)

puts "✅ Seed completed!"
puts "   #{Pole.count} pôles"
puts "   #{Unit.count} unités"
puts "   #{Schedule.count} horaires"
puts "   #{Sector.count} secteurs"
puts "   #{UnitRegulation.count} règlements"
puts "   #{EtpProgram.count} programmes ETP"
puts "   #{EtpSession.count} sessions ETP"
puts "   #{News.count} actualités"
