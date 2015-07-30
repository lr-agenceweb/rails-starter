class AddFontAwesomeIkonToSocial < ActiveRecord::Migration
  def change
    add_column :socials, :font_ikon, :string, after: :enabled
  end
end
