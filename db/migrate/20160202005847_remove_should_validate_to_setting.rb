class RemoveShouldValidateToSetting < ActiveRecord::Migration
  def change
    remove_column :settings, :should_validate
  end
end
