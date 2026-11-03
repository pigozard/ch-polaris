require "test_helper"

class EtpProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pole = Pole.create!(name: "Pôle Test", slug: "pole-test", color: "#3B82F6", position: 99)
    @utep = Unit.create!(pole: @pole, name: "UTEP Test", unit_type: "utep",
                         phone: "05 00 00 00 00", email: "utep@test.fr")
    @bipolar = EtpProgram.create!(unit: @utep, name: "Vivre avec un trouble bipolaire",
                                  pathology: "bipolar", modality: "group",
                                  prerequisites: "Entretien préalable avec l'UTEP.")
    @anxiety = EtpProgram.create!(unit: @utep, name: "Apprivoiser mon anxiété",
                                  pathology: "anxiety", modality: "individual",
                                  prerequisites: "Suivi en cours.")
  end

  # ── Liste ─────────────────────────────────────────────

  test "GET /etp liste les programmes avec leur pathologie en français" do
    get etp_programs_path
    assert_response :success
    assert_includes response.body, "Vivre avec un trouble bipolaire"
    assert_includes response.body, "Apprivoiser mon anxiété"
    assert_includes response.body, "Trouble bipolaire"
  end

  test "GET /etp affiche le prochain recrutement de chaque programme" do
    @anxiety.update!(recruitment_months: [1, 5, 9])
    get etp_programs_path
    assert_includes response.body, "Prochain recrutement"
  end

  test "GET /etp filtre par pathologie" do
    get etp_programs_path, params: { pathology: "anxiety" }
    assert_response :success
    assert_includes response.body, "Apprivoiser mon anxiété"
    assert_not_includes response.body, "Vivre avec un trouble bipolaire"
  end

  test "GET /etp ignore une pathologie inconnue" do
    get etp_programs_path, params: { pathology: "inconnue" }
    assert_response :success
    assert_includes response.body, "Vivre avec un trouble bipolaire"
    assert_includes response.body, "Apprivoiser mon anxiété"
  end

  test "GET /etp affiche le contact de l'UTEP" do
    get etp_programs_path
    assert_includes response.body, "05 00 00 00 00"
    assert_includes response.body, "mailto:utep@test.fr"
  end

  # ── Détail ────────────────────────────────────────────

  test "GET /etp/:id affiche les mois de recrutement au lieu des sessions" do
    @bipolar.update!(recruitment_months: [2, 10])
    EtpSession.create!(etp_program: @bipolar, session_type: "recurring",
                       recurrence: "Tous les mardis de 14h à 16h", status: "open")

    get etp_program_path(@bipolar)
    assert_response :success
    assert_includes response.body, "Entretien préalable avec l&#39;UTEP."
    assert_includes response.body, "février et octobre"
    assert_includes response.body, "Prochain recrutement"
    assert_not_includes response.body, "Tous les mardis de 14h à 16h"
  end

  test "GET /etp/:id résume l'essentiel dans un encadré latéral" do
    @bipolar.update!(duration: "8 séances de 2h", recruitment_months: [2, 10])
    get etp_program_path(@bipolar)
    assert_select "aside.etp-aside" do
      assert_select "h2", "L'essentiel"
      assert_select ".etp-fact", /8 séances de 2h/
      assert_select ".etp-fact", /En groupe/
      assert_select ".etp-fact", /UTEP Test/
      assert_select ".etp-next", /Prochain recrutement/
    end
    assert_select ".etp-aside-contact a[href^='mailto:utep@test.fr']"
  end

  test "GET /etp/:id présente les conditions en check-list" do
    @bipolar.update!(prerequisites: "Diagnostic posé par un psychiatre et attesté par un courrier médical. Suivi en cours.")
    get etp_program_path(@bipolar)
    assert_select "ul.etp-conditions > li", 2
    assert_select "ul.etp-conditions > li:first-child", /courrier médical/
  end

  test "GET /etp/:id explique comment participer en trois étapes" do
    get etp_program_path(@bipolar)
    assert_select "ol.etp-steps > li", 3
    assert_select "ol.etp-steps > li:first-child", /courrier médical/
  end

  test "GET /etp/:id affiche une frise des 12 mois avec le prochain recrutement" do
    @bipolar.update!(recruitment_months: [2, 10])
    get etp_program_path(@bipolar)
    assert_select ".etp-months .etp-month", 12
    assert_select ".etp-month--on", 2
    assert_select ".etp-month--next", 1
  end

  test "GET /etp/:id sans mois de recrutement renvoie vers l'UTEP" do
    get etp_program_path(@bipolar)
    assert_includes response.body, "Contactez l'UTEP"
  end

  test "GET /etp/:id propose un email à l'UTEP avec le nom du programme en objet" do
    get etp_program_path(@bipolar)
    assert_includes response.body, "mailto:utep@test.fr?subject="
    assert_includes response.body, "Vivre%20avec%20un%20trouble%20bipolaire"
  end

  test "GET /etp/:id inconnu répond 404" do
    get etp_program_path(id: 0)
    assert_response :not_found
  end
end
