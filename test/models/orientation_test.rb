require "test_helper"

class OrientationTest < ActiveSupport::TestCase
  test "chaque unité citée dans config/orientation.yml existe dans les seeds" do
    seeds = Rails.root.join("db/seeds.rb").read
    Orientation.needs.flat_map { |need| need["unites"] }.uniq.each do |slug|
      assert_includes seeds, %(slug: "#{slug}"), "unité inconnue dans orientation.yml : #{slug}"
    end
  end

  test "chaque besoin a un libellé, des mots-clés et des unités" do
    Orientation.needs.each do |need|
      assert need["libelle"].present?, "besoin sans libellé : #{need.inspect}"
      assert need["mots"].present?, "besoin sans mots-clés : #{need['libelle']}"
      assert need["unites"].present?, "besoin sans unité : #{need['libelle']}"
    end
  end

  test "needs_for renvoie les besoins d'une unité avec leurs mots-clés" do
    unit = Unit.new(slug: "centre-expert-capella")
    bipolar = Orientation.needs_for(unit).find { |n| n[:label] == "Troubles bipolaires" }
    assert bipolar
    assert_includes bipolar[:keywords], "bipolaire"
  end

  test "needs_for renvoie une liste vide pour une unité non référencée" do
    assert_empty Orientation.needs_for(Unit.new(slug: "unite-inconnue"))
  end
end
