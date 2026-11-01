# Recherche par besoin de l'annuaire : lit config/orientation.yml
# (mots-clés → unités). Aucun diagnostic, seulement où s'adresser.
class Orientation
  CONFIG_PATH = Rails.root.join("config/orientation.yml")

  def self.config
    @config ||= YAML.load_file(CONFIG_PATH)
  end

  def self.needs
    config.fetch("besoins")
  end

  # Besoins qui proposent cette unité, au format envoyé à l'annuaire
  def self.needs_for(unit)
    needs.select { |need| need["unites"].include?(unit.slug) }
         .map { |need| { label: need["libelle"], keywords: need["mots"] } }
  end
end
