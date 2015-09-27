class AddLogoFooterToSetting < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      add_attachment :settings, :logo_footer, after: :logo_file_name
    end
  end

  def self.down
    remove_attachment :settings, :logo_footer
  end
end
