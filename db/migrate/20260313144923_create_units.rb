class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.references :pole, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :unit_type, null: false
      t.integer :capacity
      t.string :phone
      t.string :email
      t.text :description
      t.string :address
      t.boolean :pmr_accessible, default: false, null: false
      t.string :parking_info
      t.string :svg_zone_id
      t.integer :position

      t.timestamps
    end

    add_index :units, :slug, unique: true
    add_index :units, :unit_type
  end
end
