class AddShowMapToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :show_map, :boolean, default: false, after: :show_qrcode
  end
end
