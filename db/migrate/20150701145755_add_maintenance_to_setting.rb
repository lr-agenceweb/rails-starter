class AddMaintenanceToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :maintenance, :boolean, default: false, after: :should_validate
  end
end
