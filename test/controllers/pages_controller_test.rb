require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @unit = Unit.create!(pole: @pole, name: "CMP Rouen", unit_type: "cmp",
                         phone: "04 00 00 00 00", email: "cmp@test.fr")
    @sector = Sector.create!(unit: @unit, postal_code: "76100", city: "Rouen")
  end

  # ── Annuaire ──────────────────────────────────────────

  test "GET /annuaire répond 200" do
    get annuaire_path
    assert_response :success
  end

  test "GET /annuaire assigne @poles et @units_json" do
    get annuaire_path
    assert_not_nil assigns(:poles)
    assert_not_nil assigns(:units_json)
  end

  test "GET /annuaire inclut les unités dans le JSON" do
    get annuaire_path
    assert_includes assigns(:units_json), "CMP Rouen"
  end

  # ── Trouver mon CMP ───────────────────────────────────

  test "GET /patients/trouver-mon-cmp avec code postal valide retourne le CMP" do
    get trouver_mon_cmp_path, params: { postal_code: "76100" }
    assert_response :success
    assert_includes response.body, "CMP Rouen"
  end

  test "GET /patients/trouver-mon-cmp avec code postal inconnu affiche message non trouvé" do
    get trouver_mon_cmp_path, params: { postal_code: "99999" }
    assert_response :success
    assert_includes response.body, "Aucun CMP"
  end

  test "GET /patients/trouver-mon-cmp avec format invalide affiche message erreur" do
    get trouver_mon_cmp_path, params: { postal_code: "abc" }
    assert_response :success
    assert_includes response.body, "code postal valide"
  end

  test "GET /patients/trouver-mon-cmp sans paramètre affiche message erreur" do
    get trouver_mon_cmp_path, params: { postal_code: "" }
    assert_response :success
    assert_includes response.body, "code postal valide"
  end

  test "GET /patients/trouver-mon-cmp ne retourne pas une unité non-CMP" do
    ward = Unit.create!(pole: @pole, name: "UH Orion 1", unit_type: "ward_open")
    Sector.create!(unit: ward, postal_code: "76100", city: "Rouen")

    get trouver_mon_cmp_path, params: { postal_code: "76100" }
    assert_response :success
    assert_not_includes response.body, "UH Orion 1"
  end
end
