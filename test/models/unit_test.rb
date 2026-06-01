require "test_helper"

class UnitTest < ActiveSupport::TestCase
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @unit = Unit.create!(
      pole: @pole, name: "CMP Test", unit_type: "cmp",
      phone: "04 00 00 00 00", email: "cmp@test.fr", pmr_accessible: true
    )
  end

  test "type_label retourne la traduction française" do
    assert_equal "Centre Médico-Psychologique", Unit.type_label("cmp")
    assert_equal "Hôpital de jour", Unit.type_label("hdj")
    assert_equal "Hospitalisation ouverte", Unit.type_label("ward_open")
    assert_equal "Hospitalisation fermée", Unit.type_label("ward_closed")
  end

  test "type_label retourne le type brut si inconnu" do
    assert_equal "unknown_type", Unit.type_label("unknown_type")
  end

  test "to_annuaire_json inclut les champs requis" do
    json = @unit.to_annuaire_json(@pole)

    assert_equal @unit.id,                             json[:id]
    assert_equal "CMP Test",                           json[:name]
    assert_equal "cmp",                                json[:type]
    assert_equal "Centre Médico-Psychologique",        json[:type_label]
    assert_equal "pole-test",                          json[:pole_slug]
    assert_equal "Pôle Test",                          json[:pole_name]
    assert_equal "#3B82F6",                            json[:pole_color]
    assert_equal "04 00 00 00 00",                     json[:phone]
    assert_equal "cmp@test.fr",                        json[:email]
    assert_equal true,                                 json[:pmr]
    assert_equal [],                                   json[:schedules]
    assert_equal [],                                   json[:sectors]
    assert_nil json[:regulation]
  end

  test "to_annuaire_json inclut les horaires" do
    Schedule.create!(unit: @unit, schedule_type: "consultation",
                     opens_at: "09:00", closes_at: "17:00", note: "Sur RDV")
    @unit.reload

    json = @unit.to_annuaire_json(@pole)
    schedule = json[:schedules].first

    assert_equal "consultation", schedule[:type]
    assert_equal "09:00",        schedule[:opens_at]
    assert_equal "17:00",        schedule[:closes_at]
    assert_equal "Sur RDV",      schedule[:note]
  end

  test "to_annuaire_json inclut les secteurs" do
    Sector.create!(unit: @unit, postal_code: "76100", city: "Rouen")
    @unit.reload

    json = @unit.to_annuaire_json(@pole)
    sector = json[:sectors].first

    assert_equal "76100", sector[:postal_code]
    assert_equal "Rouen", sector[:city]
  end

  test "to_annuaire_json inclut le règlement visite" do
    UnitRegulation.create!(unit: @unit, max_visitors: 2,
                           allowed_items: "Livres", forbidden_items: "Téléphone",
                           visiting_notes: "Sur RDV uniquement", access_info: "Bâtiment A")
    @unit.reload

    json = @unit.to_annuaire_json(@pole)

    assert_equal 2,                    json[:regulation][:max_visitors]
    assert_equal "Livres",             json[:regulation][:allowed_items]
    assert_equal "Téléphone",          json[:regulation][:forbidden_items]
    assert_equal "Sur RDV uniquement", json[:regulation][:visiting_notes]
    assert_equal "Bâtiment A",         json[:regulation][:access_info]
  end
end
