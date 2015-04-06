class AddExtraFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, after: :id
    add_column :users, :role_id, :integer, after: :last_sign_in_ip, default: 3, null: false
  end
end
