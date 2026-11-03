require "test_helper"

# Relecture métier du contenu des seeds
class SeedsContentTest < ActiveSupport::TestCase
  SEEDS = Rails.root.join("db/seeds.rb").read

  test "chaque programme ETP exige un diagnostic posé par un psychiatre, attesté par un courrier médical" do
    prerequisites = SEEDS.scan(/prerequisites: "([^"]*)"/).flatten
    assert_equal 5, prerequisites.size
    prerequisites.each do |text|
      assert text.start_with?("Diagnostic posé par un psychiatre et attesté par un courrier médical."), text
      assert_no_match(/psychologue/i, text)
    end
  end
end
