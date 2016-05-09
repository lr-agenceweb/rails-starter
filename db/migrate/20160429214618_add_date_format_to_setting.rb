class AddDateFormatToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :date_format, :integer, after: :show_admin_bar
  end
end
