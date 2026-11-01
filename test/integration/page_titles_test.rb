require "test_helper"

# WCAG 2.4.2 : chaque page a un titre d'onglet qui décrit son contenu
class PageTitlesTest < ActionDispatch::IntegrationTest
  setup do
    pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    utep = Unit.create!(pole: pole, name: "UTEP Test", unit_type: "utep")
    @program = EtpProgram.create!(unit: utep, name: "Vivre avec un trouble bipolaire", pathology: "bipolar",
                                  modality: "group", prerequisites: "Entretien préalable.")
    @news = News.create!(title: "Journée portes ouvertes", category: "event",
                         published: true, published_at: Time.zone.now)
  end

  test "chaque page a son propre titre, suivi du nom du site" do
    expected = {
      root_path => "CH Polaris — Centre Hospitalier Psychiatrique",
      hopital_path => "Notre établissement — CH Polaris",
      patients_path => "Patients et proches — CH Polaris",
      professionnels_path => "Professionnels de santé — CH Polaris",
      annuaire_path => "Annuaire des unités — CH Polaris",
      carte_path => "Plan de l'établissement — CH Polaris",
      preparer_mon_sejour_path => "Préparer mon séjour — CH Polaris",
      mes_droits_path => "Mes droits en psychiatrie — CH Polaris",
      tools_path => "Outils — CH Polaris",
      cardiac_coherence_tool_path => "Cohérence cardiaque — CH Polaris",
      etp_programs_path => "Programmes d'éducation thérapeutique — CH Polaris",
      etp_program_path(@program) => "Vivre avec un trouble bipolaire — CH Polaris",
      news_index_path => "Actualités — CH Polaris",
      news_path(@news) => "Journée portes ouvertes — CH Polaris",
      new_user_session_path => "Connexion — CH Polaris"
    }
    expected.each do |path, title|
      get path
      assert_select "head title", { text: title }, "titre inattendu sur #{path}"
    end
  end
end
