require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @unit = Unit.create!(pole: @pole, name: "CMP Rouen", unit_type: "cmp",
                         phone: "04 00 00 00 00", email: "cmp@test.fr")
    @sector = Sector.create!(unit: @unit, postal_code: "76100", city: "Rouen")
  end

  # ── Accueil ───────────────────────────────────────────

  test "GET / calcule les lits et les places ambulatoires depuis la base" do
    Unit.create!(pole: @pole, name: "Unité Test", unit_type: "ward_open", capacity: 21)
    Unit.create!(pole: @pole, name: "HDJ Test", unit_type: "hdj", capacity: 40)
    Unit.create!(pole: @pole, name: "CATTP Test", unit_type: "cattp", capacity: 12)
    get root_path
    assert_select ".stat-num", "21"
    assert_select ".stat-num", "52"
  end

  test "GET / affiche le nombre d'unités au lieu d'un effectif écrit en dur" do
    get root_path
    assert_select ".stat-label", "Unités de soins"
    assert_select ".stat-num", Unit.count.to_s
    assert_select ".stat-num", text: "650", count: 0
  end

  test "GET / place chaque libellé avant son chiffre dans la liste des chiffres clés" do
    get root_path
    assert_select ".stat-item" do |items|
      items.each { |item| assert_equal "dt", item.element_children.first.name }
    end
  end

  test "GET / enchaîne les niveaux de titres sans en sauter" do
    get root_path
    levels = css_select("h1, h2, h3, h4, h5, h6").map { |h| h.name[1].to_i }
    levels.each_cons(2) do |previous, current|
      assert_operator current, :<=, previous + 1, "saut de titre h#{previous} → h#{current}"
    end
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

  # ── Mes droits ────────────────────────────────────────

  test "GET /patients/mes-droits explique les soins sans consentement" do
    get mes_droits_path
    assert_response :success
    assert_includes response.body, "personne de confiance"
    assert_includes response.body, "juge"
  end

  test "GET /patients/mes-droits affiche le contact de la Maison des Usagers" do
    Unit.create!(pole: @pole, name: "Maison Boussole", unit_type: "users_house",
                 phone: "05 36 49 05 20", email: "usagers@test.fr")
    get mes_droits_path
    assert_includes response.body, "Maison Boussole"
    assert_includes response.body, "05 36 49 05 20"
  end

  test "GET /patients n'a plus de carte Outil d'orientation, intégrée à l'annuaire" do
    get patients_path
    assert_not_includes response.body, "Outil d&#39;orientation"
    assert_not_includes response.body, "Outil d'orientation"
    assert_select "a.hub-card--live[href=?]", annuaire_path, text: /besoin/
  end

  test "GET /patients relie la carte Mes droits" do
    get patients_path
    assert_select "a.hub-card--live[href=?]", mes_droits_path
  end

  test "GET /patients/preparer-mon-sejour renvoie vers Mes droits" do
    get preparer_mon_sejour_path
    assert_select "a[href=?]", mes_droits_path
  end

  # ── Professionnels ────────────────────────────────────

  test "les cartes À venir ne sont ni des liens ni atteignables au clavier" do
    [patients_path, professionnels_path].each do |path|
      get path
      assert_select ".hub-card--soon", minimum: 1
      assert_select "a.hub-card--soon", 0, "carte À venir en lien sur #{path}"
      assert_select ".hub-card--soon[tabindex]", 0
    end
  end

  test "GET /professionnels n'a plus de carte Adresser un patient, intégrée à l'annuaire" do
    get professionnels_path
    assert_not_includes response.body, "Adresser un patient"
    assert_select "a.hub-card--live[href=?]", annuaire_path, text: /besoin/
  end

  test "GET /professionnels relie la carte de l'établissement au plan" do
    get professionnels_path
    assert_select "a.hub-card--live[href=?]", carte_path
  end

  # ── Plan ──────────────────────────────────────────────

  test "GET /carte donne une étiquette visible au champ de recherche" do
    get carte_path
    assert_select "label[for=carte-search]", /Rechercher sur le plan/
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
                 unit_type: "crisis_unit", phone: "05 36 49 05 12")
    get preparer_mon_sejour_path
    assert_includes response.body, "Urgences Psy Polaris"
    assert_includes response.body, "05 36 49 05 12"
  end

  test "GET /patients/preparer-mon-sejour présente l'admission en logigramme : deux entrées puis trois étapes communes" do
    get preparer_mon_sejour_path
    assert_select ".sejour-flow-entry", 2
    assert_select ".sejour-flow-entry h3", /hospitalisation est programmée/
    assert_select ".sejour-flow-entry h3", /urgences psychiatriques/
    assert_select "ol.sejour-flow-steps > li", 3
    assert_select "ol.sejour-flow-steps > li:first-child", /Accueil dans l'unité/
    assert_select "ol.sejour-flow-steps > li:last-child", /Rencontre avec le psychiatre/
  end

  test "GET /patients/preparer-mon-sejour présente les affaires à apporter en check-lists illustrées" do
    get preparer_mon_sejour_path
    assert_select "ul.sejour-checklist", 2
    assert_select "ul.sejour-checklist > li", 10
    assert_select "ul.sejour-checklist > li" do |items|
      items.each { |li| assert_select li, "i.fa-solid[aria-hidden=true]", 1 }
    end
    assert_select "ul.sejour-checklist > li.sejour-checklist-avoid", /objets de valeur/
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

  test "GET /annuaire embarque les mots-clés de besoin de chaque unité" do
    Unit.create!(pole: @pole, name: "Unité Aube", slug: "unite-aube", unit_type: "perinatal")
    get annuaire_path
    assert_includes response.body, "maman"
    assert_includes response.body, "Périnatalité"
  end

  test "GET /annuaire explique la recherche par nom ou par besoin, sans exemple dans le champ" do
    get annuaire_path
    assert_select ".hub-hero p", /besoin/
    assert_select "label[for=annuaire-search]", /Rechercher une unité/
    assert_select "input#annuaire-search[aria-describedby=annuaire-search-help]:not([placeholder])"
    assert_select "#annuaire-search-help", /bipolaire/
  end

  test "GET /annuaire prépare un seul encadré d'urgence pour toutes les recherches" do
    get annuaire_path
    assert_select "[data-annuaire-target=emergency]", /3114/
    assert_select "[data-annuaire-target=reminder]", count: 0
    assert_select "[data-annuaire-emergency-value]", count: 0
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
