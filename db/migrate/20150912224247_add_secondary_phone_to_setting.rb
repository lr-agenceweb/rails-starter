class AddSecondaryPhoneToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :phone_secondary, :string, after: :phone, null: true, default: nil
  end
end
