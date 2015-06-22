class AddValidateToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :should_validate, :boolean, after: :show_social, default: false
  end
end
