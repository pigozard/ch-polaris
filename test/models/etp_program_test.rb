require "test_helper"

class EtpProgramTest < ActiveSupport::TestCase
  def program(months)
    EtpProgram.new(name: "Programme test", pathology: "anxiety", modality: "group",
                   prerequisites: "Aucun", recruitment_months: months,
                   unit: Unit.new(name: "UTEP", unit_type: "utep"))
  end

  test "recruitment_months_label liste les mois en français" do
    assert_equal "janvier, avril et septembre", program([1, 4, 9]).recruitment_months_label
  end

  test "recruitment_months_label trie les mois" do
    assert_equal "mars et novembre", program([11, 3]).recruitment_months_label
  end

  test "next_recruitment renvoie le mois de recrutement en cours" do
    assert_equal Date.new(2026, 4, 1), program([1, 4, 9]).next_recruitment(Date.new(2026, 4, 15))
  end

  test "next_recruitment renvoie le prochain mois de l'année" do
    assert_equal Date.new(2026, 9, 1), program([1, 4, 9]).next_recruitment(Date.new(2026, 5, 2))
  end

  test "next_recruitment passe à l'année suivante après le dernier mois" do
    assert_equal Date.new(2027, 1, 1), program([1, 4, 9]).next_recruitment(Date.new(2026, 11, 1))
  end

  test "next_recruitment est nil sans mois de recrutement" do
    assert_nil program([]).next_recruitment(Date.new(2026, 11, 1))
  end

  test "prerequisites_list découpe les conditions en phrases" do
    program = program([1])
    program.prerequisites = "Diagnostic posé par un psychiatre. Suivi en cours.  Entretien préalable avec l'UTEP."
    assert_equal ["Diagnostic posé par un psychiatre.", "Suivi en cours.", "Entretien préalable avec l'UTEP."],
                 program.prerequisites_list
  end

  test "un mois de recrutement doit être compris entre 1 et 12" do
    assert_not program([0, 13]).valid?
    assert program([1, 12]).valid?
  end
end
