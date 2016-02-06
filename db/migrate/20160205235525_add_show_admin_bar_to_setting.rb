class AddShowAdminBarToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :show_admin_bar, :boolean, after: :show_map, default: true
  end
end
