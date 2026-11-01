require "test_helper"

# Les icônes sont des icônes Font Awesome décoratives, pas des emojis
# (rendu identique sur tous les appareils, couleur d'accent du site)
class IconsTest < ActiveSupport::TestCase
  EMOJI = /[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}]/
  # Exceptions : ✕ des boutons « Fermer » (caractère typographique) et ☕ dessiné dans le plan SVG
  ALLOWED = %w[✕ ☕].freeze

  test "aucune vue ni controller Stimulus n'utilise d'emoji comme icône" do
    Dir[Rails.root.join("app/{views/**/*.erb,javascript/controllers/*.js}")].each do |file|
      File.read(file).scan(EMOJI).uniq.each do |emoji|
        assert_includes ALLOWED, emoji, "emoji #{emoji} dans #{file}"
      end
    end
  end
end
