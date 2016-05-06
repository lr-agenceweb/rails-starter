class AddShowFileUploadToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :show_file_upload, :boolean, default: false, after: :show_admin_bar
  end
end
