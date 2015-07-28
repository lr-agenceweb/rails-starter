class AddTwitterUsernameToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :twitter_username, :string, after: :maintenance, default: nil
  end
end
