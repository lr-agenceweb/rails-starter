class AddNameToMailingSetting < ActiveRecord::Migration
  def change
    add_column :mailing_settings, :name, :string, after: :id, default: nil
  end
end
