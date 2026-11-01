require "test_helper"

# Polices hébergées sur le site : aucune requête vers Google (l'adresse IP des visiteurs n'est pas transmise)
class SelfHostedFontsTest < ActionDispatch::IntegrationTest
  test "aucun fichier n'appelle Google Fonts" do
    Dir[Rails.root.join("app/{assets/stylesheets,views}/**/*.{css,scss,erb}")].each do |file|
      assert_no_match(/fonts\.(googleapis|gstatic)\.com/, File.read(file), "Google Fonts appelé dans #{file}")
    end
  end

  test "le CSS compilé sert les polices depuis le pipeline d'assets" do
    css = Rails.application.assets["application.css"].to_s
    assert_match %r{url\(/assets/dm-sans-latin-400-normal-\h+\.woff2\)}, css
    assert_no_match %r{url\(/fonts/}, css, "police introuvable dans app/assets/fonts"
  end

  test "les fichiers de police du site sont présents" do
    %w[dm-sans-latin-400-normal dm-sans-latin-600-normal cormorant-garamond-latin-400-normal].each do |font|
      assert Rails.root.join("app/assets/fonts/#{font}.woff2").exist?, "#{font}.woff2 manquant"
    end
  end
end
