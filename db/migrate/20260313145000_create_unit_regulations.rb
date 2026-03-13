class CreateUnitRegulations < ActiveRecord::Migration[7.1]
  def change
    create_table :unit_regulations do |t|
      t.references :unit, null: false, foreign_key: true
      t.integer :max_visitors
      t.text :forbidden_items
      t.text :allowed_items
      t.text :visiting_notes
      t.text :access_info

      t.timestamps
    end
  end
end
