require "test_helper"

# Relecture métier du contenu des seeds
class SeedsContentTest < ActiveSupport::TestCase
  SEEDS = Rails.root.join("db/seeds.rb").read

  test "aucun critère d'accès inventé dans les précisions des programmes ETP" do
    SEEDS.scan(/prerequisites: "([^"]*)"/).flatten.each do |text|
      assert_no_match(/stabilis|psychologue|sevrage/i, text)
    end
  end

  test "le programme d'addictologie demande un suivi en addictologie, sans imposer de structure" do
    assert_includes SEEDS, 'prerequisites: "Suivi en addictologie en cours."'
  end

  test "chaque programme ETP a des objectifs et des ateliers" do
    assert_equal 5, SEEDS.scan(/objectives: \[/).size
    assert_equal 5, SEEDS.scan(/workshops: \[/).size
  end
end
