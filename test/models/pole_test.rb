require "test_helper"

class PoleTest < ActiveSupport::TestCase
  test "une couleur invalide affiche un message en français" do
    pole = Pole.new(name: "Pôle Test", color: "bleu")
    assert_not pole.valid?
    assert_includes pole.errors[:color], "doit être un code hexadécimal"
  end
end
