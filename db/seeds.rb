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
  description: "Le Pôle Cassiopée assure la prise en charge psychiatrique des adultes du secteur nord du territoire de Novapolis. Il regroupe trois unités d'hospitalisation, le CMP de secteur, un hôpital de jour et un CATTP de proximité.",
  color: "#3B82F6",
  position: 1,
  transversal: false
)

orion = Pole.create!(
  name: "Pôle Orion",
  slug: "orion",
  description: "Le Pôle Orion couvre le secteur sud du territoire de Novapolis. Il propose une offre complète de soins psychiatriques adultes, de l'hospitalisation complète aux soins ambulatoires, avec trois unités d'hospitalisation et des structures de proximité.",
  color: "#8B5CF6",
  position: 2,
  transversal: false
)

lyra = Pole.create!(
  name: "Pôle Lyra",
  slug: "lyra",
  description: "Le Pôle Lyra est dédié aux prises en charge spécialisées en addictologie et réhabilitation psychosociale. Il accueille des patients adultes orientés par les équipes de secteur sur l'ensemble du territoire.",
  color: "#F97316",
  position: 3,
  transversal: false
)

pleiades = Pole.create!(
  name: "Pôle Pléiades",
  slug: "pleiades",
  description: "Le Pôle Pléiades assure la prise en charge psychiatrique des enfants et adolescents de 0 à 18 ans sur l'ensemble du territoire de Novapolis. Il dispose d'unités d'hospitalisation, d'hôpitaux de jour et de CMP dédiés par tranche d'âge.",
  color: "#22C55E",
  position: 4,
  transversal: false
)

polaris_pole = Pole.create!(
  name: "Pôle Polaris",
  slug: "polaris-transversal",
  description: "Le Pôle Polaris regroupe les structures transversales de l'établissement : CUMP, centres experts, UTEP, Maison des Usagers et équipes mobiles. Il intervient en appui et en ressource pour l'ensemble des pôles et du territoire.",
  color: "#94A3B8",
  position: 5,
  transversal: true
)

puts "🏥 Creating units..."

# ── NOUVELLES UNITÉS PÔLE POLARIS ───────────────────────
Unit.create!(
  pole: polaris_pole,
  name: "EPIC Polaris",
  slug: "epic-polaris",
  unit_type: "crisis_unit",
  capacity: nil,
  phone: "05 99 05 10 11",
  email: "epic@ch-polaris.fr",
  description: "Équipe Psychiatrique d'Intervention et de Crise. Intervient 24h/24 pour toute situation de crise psychiatrique aiguë, en lien avec le SAMU, les urgences générales et les partenaires du territoire.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-epic",
  position: 11
)

Unit.create!(
  pole: polaris_pole,
  name: "SECOP Polaris",
  slug: "secop-polaris",
  unit_type: "crisis_unit",
  capacity: nil,
  phone: "05 99 05 10 12",
  email: "secop@ch-polaris.fr",
  description: "Service d'Évaluation de Crise et d'Orientation Psychiatrique. Assure l'évaluation clinique des patients en situation de crise et leur orientation vers la structure de soins la plus adaptée.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-secop",
  position: 12
)

Unit.create!(
  pole: polaris_pole,
  name: "Unité Éclipse",
  slug: "unite-eclipse",
  unit_type: "ward_open",
  capacity: 12,
  phone: "05 99 05 10 13",
  email: "eclipse@ch-polaris.fr",
  description: "Unité Post-Urgence. Accueille les patients en sortie de crise aiguë pour une stabilisation à court terme avant orientation vers le parcours de soins adapté.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-eclipse",
  position: 13
)

Unit.create!(
  pole: polaris_pole,
  name: "Unité Aube",
  slug: "unite-aube",
  unit_type: "perinatal",
  capacity: nil,
  phone: "05 99 05 10 14",
  email: "aube@ch-polaris.fr",
  description: "Unité de Psychiatrie Périnatale. Accompagnement des femmes enceintes et des mères présentant des troubles psychiques en période périnatale, en lien avec les maternités du territoire.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-aube",
  position: 14
)

Unit.create!(
  pole: polaris_pole,
  name: "CSAPA Polaris",
  slug: "csapa-polaris",
  unit_type: "csapa",
  capacity: nil,
  phone: "05 99 05 10 15",
  email: "csapa@ch-polaris.fr",
  description: "Centre de Soins, d'Accompagnement et de Prévention en Addictologie. Accueil ambulatoire, consultations médicales et sociales, accompagnement au sevrage et réduction des risques.",
  address: "18 rue de la Comète, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Stationnement en voirie",
  svg_zone_id: "zone-csapa",
  position: 15
)

Unit.create!(
  pole: polaris_pole,
  name: "Centre Ressources Autisme Novapolis",
  slug: "cra-novapolis",
  unit_type: "expert_center",
  capacity: nil,
  phone: "05 99 05 10 16",
  email: "cra@ch-polaris.fr",
  description: "Centre Ressources Autisme du territoire de Novapolis. Bilans diagnostiques, accompagnement des familles, formation des professionnels et coordination des parcours pour les personnes autistes.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-cra",
  position: 16
)

Unit.create!(
  pole: polaris_pole,
  name: "EMAP Polaris",
  slug: "emap-polaris",
  unit_type: "mobile_team",
  capacity: nil,
  phone: "05 99 05 10 17",
  email: "emap@ch-polaris.fr",
  description: "Équipe Mobile Addiction et Parentalité. Intervient auprès des parents présentant des troubles addictifs pour prévenir les risques de négligence et soutenir la parentalité.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-emap",
  position: 18
)

Unit.create!(
  pole: polaris_pole,
  name: "EMAA Arcturus",
  slug: "emaa-arcturus",
  unit_type: "mobile_team",
  capacity: nil,
  phone: "05 99 05 10 18",
  email: "emaa@ch-polaris.fr",
  description: "Équipe Mobile Autisme Adulte. Intervient à domicile et dans les établissements médico-sociaux pour les adultes autistes en situation de crise ou de rupture de parcours.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-emaa",
  position: 19
)

Unit.create!(
  pole: polaris_pole,
  name: "MAS Les Étoiles",
  slug: "mas-les-etoiles",
  unit_type: "mas",
  capacity: 30,
  phone: "05 99 05 10 19",
  email: "mas@ch-polaris.fr",
  description: "Maison d'Accueil Spécialisée. Accueille des adultes en situation de handicap psychique sévère nécessitant un accompagnement permanent et une surveillance médicale continue.",
  address: "7 chemin des Nébuleuses, 33997 Novapolis-Nord",
  pmr_accessible: true,
  parking_info: "Parking dédié sur site",
  svg_zone_id: "zone-mas",
  position: 20
)

# ── NOUVELLES UNITÉS PÔLE PLÉIADES ──────────────────────
Unit.create!(
  pole: pleiades,
  name: "CAMSP Étoile",
  slug: "camsp-etoile",
  unit_type: "camsp",
  capacity: nil,
  phone: "05 99 04 10 09",
  email: "camsp@ch-polaris.fr",
  description: "Centre d'Action Médico-Sociale Précoce. Dépistage, diagnostic et accompagnement précoce des enfants de 0 à 6 ans présentant des troubles du développement ou des risques de handicap.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-camsp",
  position: 9
)

Unit.create!(
  pole: pleiades,
  name: "Unité Calypso",
  slug: "unite-calypso",
  unit_type: "expert_center",
  capacity: nil,
  phone: "05 99 04 10 10",
  email: "calypso@ch-polaris.fr",
  description: "Unité spécialisée dans la prise en charge des enfants et adolescents présentant des Troubles du Spectre Autistique (TSA). Bilans diagnostiques, guidance parentale et programmes d'intervention comportementale.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-calypso",
  position: 10
)

# ── PÔLE CASSIOPÉE ──────────────────────────────────────
andromede = Unit.create!(
  pole: cassiopee,
  name: "Unité Andromède",
  slug: "andromede",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 01 10 01",
  email: "andromede@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte accueillant des adultes en soins libres. L'équipe pluridisciplinaire propose un accompagnement individualisé orienté vers le rétablissement et la préparation active de la sortie.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-andromede",
  position: 1
)

persee = Unit.create!(
  pole: cassiopee,
  name: "Unité Persée",
  slug: "persee",
  unit_type: "ward_closed",
  capacity: 15,
  phone: "05 99 01 10 02",
  email: "persee@ch-polaris.fr",
  description: "Unité d'hospitalisation complète fermée accueillant des adultes en soins sans consentement et en situation de crise aiguë. Cadre sécurisé, soins intensifs et évaluation clinique approfondie.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-persee",
  position: 2
)

shedar = Unit.create!(
  pole: cassiopee,
  name: "Unité Shédar",
  slug: "shedar",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 01 10 03",
  email: "shedar@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte spécialisée dans la prise en charge des troubles de l'humeur et des dépressions sévères. Approche thérapeutique intégrative et soutien à la réinsertion.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-shedar",
  position: 3
)

cmp_cassiopee = Unit.create!(
  pole: cassiopee,
  name: "CMP Cassiopée",
  slug: "cmp-cassiopee",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 01 10 04",
  email: "cmp.cassiopee@ch-polaris.fr",
  description: "Centre Médico-Psychologique du secteur nord. Lieu pivot du soin ambulatoire, il assure les consultations psychiatriques, le suivi infirmier et l'orientation vers les structures adaptées pour les habitants du secteur nord de Novapolis.",
  address: "45 avenue de la Nébuleuse, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Stationnement en voirie — zone bleue",
  svg_zone_id: "zone-cmp-cassiopee",
  position: 4
)

Unit.create!(
  pole: cassiopee,
  name: "HDJ Céphée",
  slug: "hdj-cephee",
  unit_type: "hdj",
  capacity: 20,
  phone: "05 99 01 10 05",
  email: "hdj.cephee@ch-polaris.fr",
  description: "Hôpital de Jour proposant des soins à temps partiel pour les adultes du secteur nord. Activités thérapeutiques groupales, ateliers de réhabilitation et suivi médical ambulatoire.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-hdj-cephee",
  position: 5
)

Unit.create!(
  pole: cassiopee,
  name: "CATTP Pégase",
  slug: "cattp-pegase",
  unit_type: "cattp",
  capacity: 12,
  phone: "05 99 01 10 06",
  email: "cattp.pegase@ch-polaris.fr",
  description: "Centre d'Accueil Thérapeutique à Temps Partiel proposant des activités de soutien et de socialisation pour les patients stabilisés du secteur nord.",
  address: "8 rue de la Voie Lactée, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Parking municipal à 200m",
  svg_zone_id: "zone-cattp-pegase",
  position: 6
)

# ── PÔLE ORION ──────────────────────────────────────────
betelgeuse = Unit.create!(
  pole: orion,
  name: "Unité Bételgeuse",
  slug: "betelgeuse",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 02 10 01",
  email: "betelgeuse@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte du secteur sud. Accueil en soins libres, projet thérapeutique individualisé et préparation active de la sortie en lien avec le CMP de secteur.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-betelgeuse",
  position: 1
)

rigel = Unit.create!(
  pole: orion,
  name: "Unité Rigel",
  slug: "rigel",
  unit_type: "ward_closed",
  capacity: 15,
  phone: "05 99 02 10 02",
  email: "rigel@ch-polaris.fr",
  description: "Unité d'hospitalisation complète fermée du secteur sud. Prise en charge des situations de crise aiguë et des soins sans consentement, avec évaluation clinique et orientation vers la suite du parcours.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-rigel",
  position: 2
)

saiph = Unit.create!(
  pole: orion,
  name: "Unité Saiph",
  slug: "saiph",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 02 10 03",
  email: "saiph@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte du secteur sud, spécialisée dans la prise en charge des troubles psychotiques stabilisés et des programmes de réhabilitation précoce.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-saiph",
  position: 3
)

cmp_orion = Unit.create!(
  pole: orion,
  name: "CMP Orion",
  slug: "cmp-orion",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 02 10 04",
  email: "cmp.orion@ch-polaris.fr",
  description: "Centre Médico-Psychologique du secteur sud. Consultations psychiatriques, suivi infirmier et coordination du parcours de soins ambulatoire pour les adultes résidant dans le secteur sud de Novapolis.",
  address: "3 boulevard des Étoiles, 33998 Novapolis-Sud",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-cmp-orion",
  position: 4
)

Unit.create!(
  pole: orion,
  name: "HDJ Bellatrix",
  slug: "hdj-bellatrix",
  unit_type: "hdj",
  capacity: 20,
  phone: "05 99 02 10 05",
  email: "hdj.bellatrix@ch-polaris.fr",
  description: "Hôpital de Jour du secteur sud. Soins à temps partiel, ateliers thérapeutiques groupaux et accompagnement vers l'autonomie pour les patients du secteur sud.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P2 — accès par l'entrée sud",
  svg_zone_id: "zone-hdj-bellatrix",
  position: 5
)

Unit.create!(
  pole: orion,
  name: "CATTP Mintaka",
  slug: "cattp-mintaka",
  unit_type: "cattp",
  capacity: 12,
  phone: "05 99 02 10 06",
  email: "cattp.mintaka@ch-polaris.fr",
  description: "Centre d'Accueil Thérapeutique à Temps Partiel du secteur sud. Activités groupales de soutien et accompagnement à la réinsertion sociale et professionnelle.",
  address: "17 rue du Méridien, 33998 Novapolis-Sud",
  pmr_accessible: true,
  parking_info: "Stationnement en voirie",
  svg_zone_id: "zone-cattp-mintaka",
  position: 6
)

# ── PÔLE LYRA ───────────────────────────────────────────
vega = Unit.create!(
  pole: lyra,
  name: "Unité Véga",
  slug: "vega",
  unit_type: "ward_open",
  capacity: 20,
  phone: "05 99 03 10 01",
  email: "vega@ch-polaris.fr",
  description: "Unité de réhabilitation psychosociale en hospitalisation complète ouverte. Programme structuré visant le rétablissement fonctionnel, la remédiation cognitive et la réinsertion socioprofessionnelle.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-vega",
  position: 1
)

altair = Unit.create!(
  pole: lyra,
  name: "Unité Altaïr",
  slug: "altair",
  unit_type: "ward_closed",
  capacity: 15,
  phone: "05 99 03 10 02",
  email: "altair@ch-polaris.fr",
  description: "Unité d'addictologie en hospitalisation complète. Prise en charge des sevrages complexes, des comorbidités psychiatriques et élaboration du projet thérapeutique personnalisé.",
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
  description: "CMP spécialisé en addictologie. Consultations de suivi post-sevrage, accompagnement thérapeutique au long cours et orientation vers les dispositifs de réduction des risques du territoire.",
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
  capacity: 18,
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
  capacity: 10,
  phone: "05 99 03 10 05",
  email: "cattp.alcor@ch-polaris.fr",
  description: "CATTP spécialisé en addictologie. Groupes de parole thérapeutiques, prévention de la rechute et soutien à l'abstinence en lien avec le CMP Lyra.",
  address: "22 rue de la Lyre, 33999 Novapolis",
  pmr_accessible: false,
  parking_info: "Stationnement en voirie",
  svg_zone_id: "zone-cattp-alcor",
  position: 5
)

# ── PÔLE PLÉIADES ────────────────────────────────────────
maia = Unit.create!(
  pole: pleiades,
  name: "Unité Maia",
  slug: "maia",
  unit_type: "ward_open",
  capacity: 12,
  phone: "05 99 04 10 01",
  email: "maia@ch-polaris.fr",
  description: "Unité d'hospitalisation complète ouverte pour adolescents de 12 à 18 ans. Soins libres, scolarisation maintenue sur site et accompagnement familial intensif.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P3 — accès par l'entrée pédiatrique",
  svg_zone_id: "zone-maia",
  position: 1
)

alcyone = Unit.create!(
  pole: pleiades,
  name: "Unité Alcyone",
  slug: "alcyone",
  unit_type: "ward_closed",
  capacity: 10,
  phone: "05 99 04 10 02",
  email: "alcyone@ch-polaris.fr",
  description: "Unité d'hospitalisation complète fermée pour adolescents. Accueil en situation de crise, soins sans consentement à la demande d'un tiers et évaluations diagnostiques approfondies.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P3 — accès par l'entrée pédiatrique",
  svg_zone_id: "zone-alcyone",
  position: 2
)

cmp_pleiades = Unit.create!(
  pole: pleiades,
  name: "CMP Pléiades",
  slug: "cmp-pleiades",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 04 10 03",
  email: "cmp.pleiades@ch-polaris.fr",
  description: "CMP de pédopsychiatrie pour enfants de 0 à 11 ans. Consultations diagnostiques, bilans développementaux, suivis thérapeutiques et guidance parentale sur l'ensemble du territoire.",
  address: "5 allée des Comètes, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking gratuit attenant",
  svg_zone_id: "zone-cmp-pleiades",
  position: 3
)

cmp_electre = Unit.create!(
  pole: pleiades,
  name: "CMP Électre",
  slug: "cmp-electre",
  unit_type: "cmp",
  capacity: nil,
  phone: "05 99 04 10 04",
  email: "cmp.electre@ch-polaris.fr",
  description: "CMP dédié aux adolescents de 12 à 18 ans. Consultations psychiatriques, suivis psychologiques, groupes thérapeutiques et coordination avec les établissements scolaires du territoire.",
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
  capacity: 15,
  phone: "05 99 04 10 05",
  email: "hdj.merope@ch-polaris.fr",
  description: "Hôpital de Jour pour enfants de 6 à 12 ans. Soins intensifs à temps partiel, ateliers thérapeutiques, soutien aux apprentissages et travail avec les familles.",
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
  capacity: 15,
  phone: "05 99 04 10 06",
  email: "hdj.taygete@ch-polaris.fr",
  description: "Hôpital de Jour pour adolescents de 12 à 18 ans. Programme thérapeutique structuré, groupes de pairs, préparation à l'autonomie et articulation avec les dispositifs de droit commun.",
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
  capacity: 8,
  phone: "05 99 04 10 07",
  email: "cattp.asterope@ch-polaris.fr",
  description: "CATTP adolescents. Activités thérapeutiques groupales, soutien à la socialisation et accompagnement vers les dispositifs de droit commun.",
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
  capacity: 10,
  phone: "05 99 04 10 08",
  email: "sessad.celene@ch-polaris.fr",
  description: "Service d'Éducation Spéciale et de Soins À Domicile. Accompagnement des enfants et adolescents présentant des troubles psychiques dans leur milieu de vie naturel.",
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
  description: "Cellule d'Urgence Médico-Psychologique. Intervient lors d'événements traumatiques collectifs pour assurer le soutien psychologique immédiat des victimes, des témoins et des professionnels.",
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
  description: "Centre Expert en dépression résistante. Évaluation pluridisciplinaire et prise en charge des patients en situation d'échec thérapeutique, avec accès à des protocoles spécialisés.",
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
  description: "Centre Expert Autisme Adulte. Bilans diagnostiques approfondis, accompagnement thérapeutique spécialisé et soutien à l'inclusion professionnelle des personnes autistes adultes.",
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
  description: "Centre Expert Troubles Bipolaires. Éducation thérapeutique spécialisée, prévention des rechutes et optimisation des traitements de stabilisation de l'humeur.",
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
  description: "Unité Transversale d'Éducation du Patient. Coordonne et développe les programmes d'éducation thérapeutique du patient pour l'ensemble de l'établissement, en lien avec les équipes soignantes des cinq pôles.",
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
  description: "Maison des Usagers ouverte à tous les patients, familles et proches. Espace d'information, d'écoute et de soutien animé par des associations de patients et de familles partenaires de l'établissement.",
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
  description: "Équipe Mobile Psychiatrie Précarité. Intervient auprès des personnes en situation de grande précarité présentant des troubles psychiques, en lien étroit avec les acteurs sociaux du territoire.",
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
  description: "Équipe Mobile Psychiatrie Personne Âgée. Évaluations et interventions à domicile ou en EHPAD pour les personnes âgées présentant des troubles psychiques, en coordination avec les équipes gériatriques.",
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
  description: "Unité de Liaison Psychiatrique. Intervient dans les services de médecine et de chirurgie du territoire pour les patients présentant des comorbidités psychiatriques nécessitant une expertise spécialisée.",
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
  capacity: 25,
  phone: "05 99 05 10 10",
  email: "longue-duree@ch-polaris.fr",
  description: "Unité de soins de longue durée pour patients nécessitant une prise en charge psychiatrique au long cours dans un cadre hospitalier sécurisé et adapté.",
  address: "12 rue des Astres, 33999 Novapolis",
  pmr_accessible: true,
  parking_info: "Parking P1 — accès par l'entrée principale",
  svg_zone_id: "zone-longue-duree",
  position: 10
)

puts "🕐 Creating schedules..."

# Unités ouvertes — visites
[andromede, shedar, betelgeuse, saiph, vega, maia].each do |unit|
  Schedule.create!(
    unit: unit,
    schedule_type: "visiting",
    opens_at: "14:00",
    closes_at: "19:00",
    note: "2 visiteurs maximum par patient — présentation obligatoire à l'accueil de l'unité"
  )
end

# Unités fermées — visites sur autorisation
[persee, rigel, altair, alcyone].each do |unit|
  Schedule.create!(
    unit: unit,
    schedule_type: "visiting",
    opens_at: "14:00",
    closes_at: "18:00",
    note: "Visites soumises à validation préalable par l'équipe soignante — modalités communiquées lors de l'admission"
  )
end

# CMP — consultations et téléphone
[cmp_cassiopee, cmp_orion, cmp_lyra, cmp_pleiades, cmp_electre].each do |unit|
  Schedule.create!(
    unit: unit,
    schedule_type: "consultation",
    opens_at: "08:30",
    closes_at: "17:30",
    note: "Sur rendez-vous — lundi au vendredi"
  )
  Schedule.create!(
    unit: unit,
    schedule_type: "phone",
    opens_at: "08:30",
    closes_at: "17:30",
    note: "Accueil téléphonique du lundi au vendredi"
  )
end

# HDJ — accueil
Unit.where(unit_type: "hdj").each do |unit|
  Schedule.create!(
    unit: unit,
    schedule_type: "consultation",
    opens_at: "08:30",
    closes_at: "16:30",
    note: "Du lundi au vendredi — sur orientation médicale"
  )
end

# CATTP — accueil
Unit.where(unit_type: "cattp").each do |unit|
  Schedule.create!(
    unit: unit,
    schedule_type: "consultation",
    opens_at: "09:00",
    closes_at: "16:00",
    note: "Du lundi au vendredi"
  )
end

# Structures transversales — accueil
Unit.where(unit_type: %w[utep users_house empp ulpsy cump expert_center]).each do |unit|
  Schedule.create!(
    unit: unit,
    schedule_type: "consultation",
    opens_at: "09:00",
    closes_at: "17:00",
    note: "Du lundi au vendredi — sur rendez-vous"
  )
end

puts "📍 Creating sectors..."

# CMP Cassiopée — secteur nord
[
  { postal_code: "33999", city: "Novapolis" },
  { postal_code: "33997", city: "Novapolis-Nord" },
  { postal_code: "33996", city: "Saint-Astre" },
  { postal_code: "33994", city: "Bellerive" },
  { postal_code: "33993", city: "Hauterive" }
].each { |s| Sector.create!(unit: cmp_cassiopee, **s) }

# CMP Orion — secteur sud
[
  { postal_code: "33998", city: "Novapolis-Sud" },
  { postal_code: "33995", city: "Belvédère" },
  { postal_code: "33992", city: "Val-Serein" },
  { postal_code: "33991", city: "Fontmerle" }
].each { |s| Sector.create!(unit: cmp_orion, **s) }

puts "📋 Creating unit regulations..."

# Règlement commun hospitalisation
forbidden = ["téléphone portable", "ordinateur", "alcool", "médicaments personnels non validés par l'équipe", "objets tranchants", "cordons et lacets", "briquet"].to_json
allowed = ["livres et magazines", "vêtements personnels sans cordon", "photos de proches", "jeux de société", "produits d'hygiène non alcoolisés"].to_json

# Unités ouvertes
[andromede, shedar, betelgeuse, saiph, vega, maia].each do |unit|
  UnitRegulation.create!(
    unit: unit,
    max_visitors: 2,
    forbidden_items: forbidden,
    allowed_items: allowed,
    visiting_notes: "Les visites ont lieu tous les jours de 14h à 19h. Les mineurs de moins de 12 ans ne sont pas admis sans accord médical préalable. Merci de vous présenter à l'accueil de l'unité muni d'une pièce d'identité.",
    access_info: "Accès PMR par l'entrée principale. Ascenseur disponible. Interphone à l'entrée de l'unité."
  )
end

# Unités fermées
[persee, rigel, altair, alcyone].each do |unit|
  UnitRegulation.create!(
    unit: unit,
    max_visitors: 2,
    forbidden_items: forbidden,
    allowed_items: allowed,
    visiting_notes: "Les visites sont soumises à validation préalable par l'équipe soignante. Les horaires et modalités sont communiqués lors de l'admission. Fouille des effets personnels à l'entrée.",
    access_info: "Accès PMR disponible. Interphone sécurisé. Sas d'entrée obligatoire."
  )
end

puts "🎓 Creating ETP programs..."

prog_bipolaire = EtpProgram.create!(
  unit: utep,
  name: "Vivre avec un trouble bipolaire",
  description: "Programme d'éducation thérapeutique destiné aux personnes diagnostiquées avec un trouble bipolaire. Il vise à améliorer la connaissance de la maladie, la reconnaissance des prodromes et la gestion du traitement thymorégulateur.",
  target_audience: "Patients adultes diagnostiqués trouble bipolaire type I ou II, en phase de stabilisation",
  pathology: "bipolar",
  prerequisites: "Diagnostic posé par un psychiatre. Être en phase de stabilisation depuis au moins 3 mois. Entretien individuel préalable avec une infirmière coordinatrice de l'UTEP.",
  duration: "8 séances de 2h",
  modality: "group"
)

prog_depression = EtpProgram.create!(
  unit: utep,
  name: "Comprendre et agir sur ma dépression",
  description: "Programme destiné aux personnes souffrant de dépression récurrente ou résistante. Il aborde la compréhension des mécanismes dépressifs, la gestion du traitement antidépresseur et les stratégies de prévention des rechutes.",
  target_audience: "Patients adultes avec dépression récurrente (au moins 2 épisodes) ou résistante",
  pathology: "depression",
  prerequisites: "Suivi psychiatrique en cours. Au moins un épisode dépressif traité. Entretien préalable avec l'UTEP. Accord du psychiatre référent.",
  duration: "6 séances de 2h",
  modality: "group"
)

prog_addiction = EtpProgram.create!(
  unit: utep,
  name: "Mon parcours de soins en addictologie",
  description: "Programme transversal pour les patients engagés dans un parcours de soins en addictologie. Aborde la compréhension des mécanismes de dépendance, la prévention de la rechute et la construction du projet de vie.",
  target_audience: "Patients adultes en suivi addictologique au CMP Lyra ou en HDJ Deneb",
  pathology: "addiction",
  prerequisites: "Être suivi au CMP Lyra ou en HDJ Deneb. Sevrage stabilisé. Motivation exprimée lors d'un entretien infirmier préalable.",
  duration: "5 séances de 2h30",
  modality: "mixed"
)

prog_anxiete = EtpProgram.create!(
  unit: utep,
  name: "Apprivoiser mon anxiété",
  description: "Programme destiné aux personnes souffrant de troubles anxieux. Psychoéducation sur les mécanismes anxieux, techniques de gestion du stress et outils de régulation émotionnelle.",
  target_audience: "Patients adultes avec troubles anxieux diagnostiqués (TAG, TOC, phobie sociale, trouble panique)",
  pathology: "anxiety",
  prerequisites: "Diagnostic établi par un psychiatre ou psychologue. Suivi en cours. Entretien individuel préalable avec l'UTEP.",
  duration: "6 séances de 1h30",
  modality: "group"
)

prog_schizo = EtpProgram.create!(
  unit: utep,
  name: "Vivre avec la schizophrénie",
  description: "Programme d'éducation thérapeutique pour les personnes vivant avec un trouble schizophrénique ou apparenté. Connaissance de la maladie, gestion du traitement antipsychotique et stratégies de coping.",
  target_audience: "Patients adultes avec diagnostic de schizophrénie ou trouble schizo-affectif stabilisés",
  pathology: "schizophrenia",
  prerequisites: "Diagnostic posé. Stabilisation clinique depuis au moins 6 mois. Accord du psychiatre référent. Entretien préalable avec l'UTEP.",
  duration: "8 séances de 2h",
  modality: "group"
)

puts "📅 Creating ETP sessions..."

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
  registration_info: "Nouvelle session. Inscriptions ouvertes jusqu'au #{(Date.today + 30).strftime('%d/%m/%Y')}. Contacter l'UTEP au 05 99 05 10 05."
)

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
  registration_info: "Inscriptions ouvertes jusqu'au #{(Date.today + 15).strftime('%d/%m/%Y')}. Contacter l'UTEP."
)

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

EtpSession.create!(
  etp_program: prog_schizo,
  session_type: "recurring",
  recurrence: "Tous les lundis de 14h à 16h",
  max_participants: 8,
  current_participants: 5,
  location: "Salle Étoile — UTEP, Bâtiment principal",
  status: "open",
  registration_info: "Sur orientation du psychiatre référent. Entretien préalable obligatoire avec l'UTEP."
)

puts "📰 Creating news..."

News.create!(
  pole: nil,
  title: "Journée Mondiale de la Santé Mentale — Le CH Polaris mobilisé",
  slug: "journee-mondiale-sante-mentale-2025",
  summary: "À l'occasion de la Journée Mondiale de la Santé Mentale du 10 octobre, le CH Polaris organise une journée portes ouvertes et des ateliers de sensibilisation ouverts au grand public.",
  category: "health_day",
  published_at: Date.today - 10,
  published: true
)

News.create!(
  pole: polaris_pole,
  title: "Ouverture d'un nouveau groupe ETP dédié aux troubles bipolaires",
  slug: "nouveau-groupe-etp-bipolaire-2025",
  summary: "L'UTEP Étoile Polaire ouvre une nouvelle session du programme « Vivre avec un trouble bipolaire » à partir du mois prochain. Les inscriptions sont ouvertes sur entretien infirmier.",
  category: "announcement",
  published_at: Date.today - 5,
  published: true
)

News.create!(
  pole: cassiopee,
  title: "Le Pôle Cassiopée obtient la certification HAS avec mention",
  slug: "pole-cassiopee-certification-has-2025",
  summary: "La Haute Autorité de Santé a certifié le Pôle Cassiopée avec mention, saluant la qualité de la prise en charge, la démarche qualité et l'implication des équipes soignantes.",
  category: "institutional",
  published_at: Date.today - 2,
  published: true
)

News.create!(
  pole: cassiopee,
  title: "Bienvenue au Dr. Lemaire, nouveau psychiatre à l'Unité Andromède",
  slug: "bienvenue-dr-lemaire-andromede",
  summary: "Le CH Polaris accueille le Dr. Sophie Lemaire, psychiatre spécialisée dans les troubles de l'humeur, qui rejoint l'équipe de l'Unité Andromède à compter du 1er novembre.",
  category: "announcement",
  published_at: Date.today - 30,
  published: true
)

News.create!(
  pole: nil,
  title: "Le groupe de travail éthique remet son rapport à la direction",
  slug: "rapport-groupe-travail-ethique-2025",
  summary: "Le groupe de travail pluridisciplinaire sur l'éthique clinique a remis son rapport annuel à la direction du CH Polaris. Ce document aborde les enjeux de l'isolement thérapeutique et du consentement aux soins.",
  category: "institutional",
  published_at: Date.today - 45,
  published: true
)

News.create!(
  pole: nil,
  title: "La Semaine Culturelle du CH Polaris arrive — inscrivez-vous !",
  slug: "semaine-culturelle-ch-polaris-2025",
  summary: "Du 18 au 22 novembre, le CH Polaris organise sa Semaine Culturelle annuelle : expositions, concerts, ateliers créatifs ouverts aux patients, familles et professionnels. Programme complet disponible à l'accueil.",
  category: "event",
  published_at: Date.today - 60,
  published: true
)

News.create!(
  pole: nil,
  title: "Le CH Polaris rejoint le GHT Nouvelle-Aquitaine Atlantique",
  slug: "ch-polaris-ght-nouvelle-aquitaine-atlantique",
  summary: "Le Centre Hospitalier Polaris intègre le Groupement Hospitalier de Territoire Nouvelle-Aquitaine Atlantique, renforçant ainsi les coopérations territoriales et la continuité des parcours de soins.",
  category: "institutional",
  published_at: Date.today - 75,
  published: true
)

News.create!(
  pole: polaris_pole,
  title: "L'EMPP Lumière étend ses interventions au territoire de Val-Serein",
  slug: "empp-lumiere-extension-val-serein",
  summary: "Suite à un partenariat avec le CCAS de Val-Serein, l'Équipe Mobile Psychiatrie Précarité étend désormais ses maraudes et interventions au territoire de Val-Serein, en lien avec les équipes sociales locales.",
  category: "announcement",
  published_at: Date.today - 90,
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
puts ""
puts "📊 Capacités :"
puts "   Lits hospitalisation : #{Unit.where(unit_type: %w[ward_open ward_closed long_stay]).sum(:capacity)}"
puts "   Places ambulatoires : #{Unit.where(unit_type: %w[hdj cattp sessad]).sum(:capacity)}"
