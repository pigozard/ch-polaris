class AddContentToEtpPrograms < ActiveRecord::Migration[7.1]
  def change
    # Contenu d'un programme ETP : objectifs, ateliers numérotés, ouverture aux proches
    add_column :etp_programs, :objectives, :text, array: true, default: [], null: false
    add_column :etp_programs, :workshops, :text, array: true, default: [], null: false
    add_column :etp_programs, :open_to_relatives, :boolean, default: false, null: false
    # Les conditions d'accès sont communes à tous les programmes (EtpProgram::ACCESS_CONDITIONS) ;
    # prerequisites ne garde que les précisions propres à un programme, facultatives
    change_column_null :etp_programs, :prerequisites, true
  end
end
