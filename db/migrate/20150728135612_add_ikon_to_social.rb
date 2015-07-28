class AddIkonToSocial < ActiveRecord::Migration
  def self.up
    change_table :socials do |t|
      add_attachment :socials, :ikon, after: :enabled
      add_column :socials, :retina_dimensions, :text, after: :ikon_file_name
    end
  end

  def self.down
    remove_attachment :socials, :ikon
    remove_column :socials, :retina_dimensions, :text
  end
end
