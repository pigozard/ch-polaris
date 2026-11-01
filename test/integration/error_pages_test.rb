require "test_helper"

# Pages d'erreur statiques (public/) : elles doivent s'afficher même si Rails est en panne
class ErrorPagesTest < ActiveSupport::TestCase
  { "404" => "Page introuvable", "422" => "Demande refusée", "500" => "Une erreur est survenue" }.each do |code, heading|
    test "la page #{code} est en français, avec un retour à l'accueil et les numéros d'urgence" do
      html = Rails.root.join("public/#{code}.html").read
      assert_includes html, '<html lang="fr">'
      assert_includes html, "<h1>#{heading}</h1>"
      assert_includes html, 'href="/"'
      assert_includes html, "3114"
      assert_includes html, "Site fictif de démonstration"
    end
  end
end
