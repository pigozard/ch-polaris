require "test_helper"

class NewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @older = News.create!(title: "Journée portes ouvertes", category: "event",
                          summary: "Venez découvrir l'établissement.",
                          content: "<p>Programme détaillé de la journée.</p>",
                          published: true, published_at: Time.zone.local(2026, 10, 5))
    @newer = News.create!(title: "Nouveau groupe ETP", category: "announcement", pole: @pole,
                          published: true, published_at: Time.zone.local(2026, 10, 20))
    @draft = News.create!(title: "Brouillon interne", category: "announcement",
                          published: false)
  end

  # ── Liste ─────────────────────────────────────────────

  test "GET /actualites liste les actualités publiées, la plus récente en premier" do
    get news_index_path
    assert_response :success
    assert_operator response.body.index("Nouveau groupe ETP"), :<, response.body.index("Journée portes ouvertes")
  end

  test "GET /actualites n'affiche pas les brouillons" do
    get news_index_path
    assert_not_includes response.body, "Brouillon interne"
  end

  test "GET /actualites affiche les dates en français" do
    get news_index_path
    assert_includes response.body, "20 octobre 2026"
  end

  test "GET /actualites renvoie vers le détail par slug" do
    get news_index_path
    assert_includes response.body, news_path(@older)
    assert_includes news_path(@older), "/actualites/journee-portes-ouvertes"
  end

  # ── Détail ────────────────────────────────────────────

  test "GET /actualites/:slug affiche le résumé et le contenu" do
    get news_path(@older)
    assert_response :success
    assert_includes response.body, "Venez découvrir l&#39;établissement."
    assert_includes response.body, "Programme détaillé de la journée."
  end

  test "GET /actualites/:slug d'un brouillon répond 404" do
    get news_path(@draft)
    assert_response :not_found
  end

  test "GET /actualites/:slug inconnu répond 404" do
    get news_path("inconnu")
    assert_response :not_found
  end
end
