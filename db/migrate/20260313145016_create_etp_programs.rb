class CreateEtpPrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :etp_programs do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :target_audience
      t.string :pathology, null: false
      t.text :prerequisites, null: false
      t.string :duration
      t.string :modality, null: false

      t.timestamps
    end
  end
end
