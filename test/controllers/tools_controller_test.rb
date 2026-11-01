require "test_helper"

class ToolsControllerTest < ActionDispatch::IntegrationTest
  # ── Liste des outils ──────────────────────────────────

  test "GET /patients/outils liste la cohérence cardiaque" do
    get tools_path
    assert_response :success
    assert_select "h1", "Outils"
    assert_select "a.hub-card--live[href=?]", cardiac_coherence_tool_path
  end

  test "GET /patients relie la carte Outils" do
    get patients_path
    assert_select "a.hub-card--live[href=?]", tools_path, text: /Outils/
    assert_not_includes response.body, "Outils bien-être"
  end

  # ── Cohérence cardiaque ───────────────────────────────

  test "GET /patients/outils/coherence-cardiaque affiche l'exercice avec Clara" do
    get cardiac_coherence_tool_path
    assert_response :success
    assert_select "h1", /Cohérence cardiaque/
    assert_select "h2", "Respirez avec Clara"
    assert_select "[data-controller=breathing]"
  end

  test "GET /patients/outils/coherence-cardiaque propose 3, 5 et 10 minutes" do
    get cardiac_coherence_tool_path
    %w[3 5 10].each do |minutes|
      assert_select "input[type=radio][value=?]", minutes
    end
  end

  test "GET /patients/outils/coherence-cardiaque précise que ce n'est pas un soin" do
    get cardiac_coherence_tool_path
    assert_includes response.body, "Outil de bien-être, pas un soin"
    assert_includes response.body, "3114"
  end

  test "GET /patients/outils/coherence-cardiaque renvoie vers la liste des outils" do
    get cardiac_coherence_tool_path
    assert_select "a.hub-switch-link[href=?]", tools_path
  end
end
