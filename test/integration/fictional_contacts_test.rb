require "test_helper"

# Coordonnées fictives : numéros de la plage ARCEP réservée aux œuvres de fiction (05 36 49 xx xx),
# jamais attribués, et emails en .fictif, qui ne peuvent arriver chez personne
class FictionalContactsTest < ActiveSupport::TestCase
  FILES = Dir[Rails.root.join("{app/views/**/*.erb,db/seeds.rb,public/*.html,README.md}")].freeze
  PHONE = /\b0\d(?:[ .]?\d{2}){4}\b/

  test "tous les numéros affichés sont dans la plage fictive 05 36 49" do
    FILES.each do |file|
      File.read(file).scan(PHONE).each do |phone|
        assert phone.delete(" .").start_with?("053649"), "numéro non fictif #{phone} dans #{file}"
      end
    end
  end

  test "aucun nom de région ou de groupement hospitalier réel" do
    FILES.each do |file|
      assert_no_match(/Nouvelle-Aquitaine/i, File.read(file), "nom réel dans #{file}")
    end
  end

  test "aucune adresse email en ch-polaris.fr" do
    FILES.each do |file|
      assert_no_match(/@ch-polaris\.fr\b/, File.read(file), "email réel possible dans #{file}")
    end
  end
end
