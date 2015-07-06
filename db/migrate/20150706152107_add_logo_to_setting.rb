class AddLogoToSetting < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      add_attachment :settings, :logo, after: :maintenance
      add_column :settings, :retina_dimensions, :text, after: :logo_file_name
    end
  end

  def self.down
    remove_attachment :settings, :logo
    remove_column :settings, :retina_dimensions, :text
  end
end
