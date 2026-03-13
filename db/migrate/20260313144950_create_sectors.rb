class CreateSectors < ActiveRecord::Migration[7.1]
  def change
    create_table :sectors do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :postal_code, null: false
      t.string :city, null: false
      t.string :street_pattern

      t.timestamps
    end

    add_index :sectors, :postal_code
  end
end
