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

  test "GET /etp/:id affiche le programme et ses sessions" do
    EtpSession.create!(etp_program: @bipolar, session_type: "recurring",
                       recurrence: "Tous les mardis de 14h à 16h",
                       max_participants: 8, current_participants: 6, status: "open")

    get etp_program_path(@bipolar)
    assert_response :success
    assert_includes response.body, "Entretien préalable avec l&#39;UTEP."
    assert_includes response.body, "Tous les mardis de 14h à 16h"
    assert_includes response.body, "2 places restantes"
    assert_includes response.body, "Ouvert"
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
