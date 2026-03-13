class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :schedule_type, null: false
      t.time :opens_at
      t.time :closes_at
      t.string :note

      t.timestamps
    end
  end
end
