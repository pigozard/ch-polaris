require "test_helper"

# Relecture métier du contenu des seeds
class SeedsContentTest < ActiveSupport::TestCase
  SEEDS = Rails.root.join("db/seeds.rb").read

  test "dans les programmes ETP, tout diagnostic est posé par un psychiatre" do
    prerequisites = SEEDS.scan(/prerequisites: "([^"]*)"/).flatten
    assert_equal 5, prerequisites.size
    prerequisites.grep(/diagnostic/i).each do |text|
      assert_match(/Diagnostic posé par un psychiatre\./, text)
      assert_no_match(/psychologue/i, text)
    end
  end
end
