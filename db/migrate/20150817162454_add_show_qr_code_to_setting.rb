class AddShowQrCodeToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :show_qrcode, :boolean, after: :show_social, default: false
  end
end
