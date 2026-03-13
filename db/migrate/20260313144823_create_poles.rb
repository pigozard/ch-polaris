class CreatePoles < ActiveRecord::Migration[7.1]
  def change
    create_table :poles do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :color, null: false
      t.integer :position
      t.boolean :transversal, default: false, null: false

      t.timestamps
    end

    add_index :poles, :slug, unique: true
  end
end
