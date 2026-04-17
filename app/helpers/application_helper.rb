module ApplicationHelper
  CATEGORIES_FR = {
    "event"        => "Événement",
    "announcement" => "Annonce",
    "health_day"   => "Journée de santé",
    "institutional" => "Institutionnel"
  }.freeze

  UNIT_TYPES_FR = {
    "ward_open"    => "Hospitalisation ouverte",
    "ward_closed"  => "Hospitalisation fermée",
    "cmp"          => "Centre Médico-Psychologique",
    "hdj"          => "Hôpital de Jour",
    "cattp"        => "CATTP",
    "sessad"       => "SESSAD",
    "empp"         => "Équipe Mobile Psychiatrie Précarité",
    "mobile_team"  => "Équipe Mobile Spécialisée",
    "ulpsy"        => "Unité de Liaison Psychiatrique",
    "cump"         => "Cellule d'Urgence Médico-Psychologique",
    "expert_center" => "Centre Expert",
    "utep"         => "UTEP",
    "users_house"  => "Maison des Usagers",
    "long_stay"    => "Soins de Longue Durée",
    "csapa"        => "CSAPA",
    "mas"          => "Maison d'Accueil Spécialisée",
    "camsp"        => "CAMSP",
    "crisis_unit"  => "Unité de Crise",
    "perinatal"    => "Psychiatrie Périnatale"
  }.freeze

  def category_fr(category)
    CATEGORIES_FR[category] || category.humanize
  end

  def unit_type_fr(unit_type)
    UNIT_TYPES_FR[unit_type] || unit_type.humanize
  end
end
