class CreateNews < ActiveRecord::Migration[7.1]
  def change
    create_table :news do |t|
      t.references :pole, null: true, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.text :summary
      t.string :category, null: false
      t.datetime :published_at
      t.boolean :published, default: false, null: false

      t.timestamps
    end

    add_index :news, :slug, unique: true
    add_index :news, :published
  end
end
