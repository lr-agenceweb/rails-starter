class AddPerPageToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :per_page, :integer, after: :email, default: 3
  end
end
