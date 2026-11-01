class AddRecruitmentMonthsToEtpPrograms < ActiveRecord::Migration[7.1]
  def change
    # Mois de démarrage des groupes (1 = janvier … 12 = décembre), à la place de sessions à dates fixes
    add_column :etp_programs, :recruitment_months, :integer, array: true, default: [], null: false
  end
end
