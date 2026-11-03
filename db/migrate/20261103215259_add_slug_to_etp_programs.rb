class AddSlugToEtpPrograms < ActiveRecord::Migration[7.1]
  # Adresse lisible et stable (/etp/vivre-avec-un-trouble-bipolaire) au lieu de l'identifiant numérique
  def up
    add_column :etp_programs, :slug, :string
    # Remplit le slug des programmes déjà en base, à partir de leur nom
    select_rows("SELECT id, name FROM etp_programs").each do |id, name|
      execute("UPDATE etp_programs SET slug = #{quote(name.parameterize)} WHERE id = #{id.to_i}")
    end
    change_column_null :etp_programs, :slug, false
    add_index :etp_programs, :slug, unique: true
  end

  def down
    remove_column :etp_programs, :slug
  end
end
