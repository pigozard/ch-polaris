require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @unit = Unit.create!(pole: @pole, name: "CMP Rouen", unit_type: "cmp",
                         phone: "04 00 00 00 00", email: "cmp@test.fr")
    @sector = Sector.create!(unit: @unit, postal_code: "76100", city: "Rouen")
  end

  # ── Hôpital ───────────────────────────────────────────

  test "GET /hopital affiche la date des actualités en français et un lien vers le détail" do
    news = News.create!(title: "Semaine culturelle", category: "event",
                        published: true, published_at: Time.zone.local(2026, 3, 12))
    get hopital_path
    assert_includes response.body, "12 mars 2026"
    assert_includes response.body, news_path(news)
    assert_includes response.body, news_index_path
  end

  # ── Préparer mon séjour ───────────────────────────────

  test "GET /patients/preparer-mon-sejour affiche le parking de chaque unité d'hospitalisation" do
    Unit.create!(pole: @pole, name: "Unité Véga", unit_type: "ward_open",
                 parking_info: "Parking P1 — accès par l'entrée principale")
    get preparer_mon_sejour_path
    assert_response :success
    assert_includes response.body, "Unité Véga"
    assert_includes response.body, "Parking P1 — accès par l&#39;entrée principale"
  end

  test "GET /patients/preparer-mon-sejour n'affiche pas les unités sans hospitalisation" do
    get preparer_mon_sejour_path
    assert_not_includes response.body, "CMP Rouen"
  end

  test "GET /patients/preparer-mon-sejour décrit l'arrivée par les urgences psy" do
    Unit.create!(pole: @pole, name: "Urgences Psy Polaris", slug: "urgences-psy-polaris",
                 unit_type: "crisis_unit", phone: "05 99 05 10 12")
    get preparer_mon_sejour_path
    assert_includes response.body, "Urgences Psy Polaris"
    assert_includes response.body, "05 99 05 10 12"
  end

  test "GET /patients/preparer-mon-sejour renvoie vers l'annuaire et le plan" do
    get preparer_mon_sejour_path
    assert_includes response.body, annuaire_path
    assert_includes response.body, carte_path
  end

  test "GET /patients relie la carte Préparer mon séjour" do
    get patients_path
    assert_includes response.body, preparer_mon_sejour_path
  end

  # ── Annuaire ──────────────────────────────────────────

  test "GET /annuaire répond 200" do
    get annuaire_path
    assert_response :success
  end

  test "GET /annuaire inclut les unités dans le JSON embarqué" do
    get annuaire_path
    assert_includes response.body, "CMP Rouen"
    assert_includes response.body, "data-annuaire-units-value"
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

  test "GET /patients/trouver-mon-cmp filtre par public" do
    @unit.update!(audience: "adult")
    child_cmp = Unit.create!(pole: @pole, name: "CMP Enfants Rouen", unit_type: "cmp", audience: "child")
    Sector.create!(unit: child_cmp, postal_code: "76100", city: "Rouen")

    get trouver_mon_cmp_path, params: { postal_code: "76100", audience: "child" }
    assert_response :success
    assert_includes response.body, "CMP Enfants Rouen"
    assert_includes response.body, "Enfants (0–11 ans)"
    assert_not_includes response.body, "CMP Rouen<"
  end

  test "GET /patients/trouver-mon-cmp sans CMP pour ce public affiche message non trouvé" do
    @unit.update!(audience: "adult")

    get trouver_mon_cmp_path, params: { postal_code: "76100", audience: "teen" }
    assert_response :success
    assert_includes response.body, "Aucun CMP"
  end
end
