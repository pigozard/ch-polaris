class CreateEtpSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :etp_sessions do |t|
      t.references :etp_program, null: false, foreign_key: true
      t.string :session_type, null: false
      t.date :starts_on
      t.date :ends_on
      t.string :recurrence
      t.integer :max_participants
      t.integer :current_participants, default: 0
      t.string :location
      t.string :status, null: false, default: 'open'
      t.text :registration_info

      t.timestamps
    end
  end
end
