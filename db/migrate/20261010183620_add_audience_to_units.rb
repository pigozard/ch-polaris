class AddAudienceToUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :units, :audience, :string
  end
end
