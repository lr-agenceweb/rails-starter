class CreateMailingSettings < ActiveRecord::Migration
  def change
    create_table :mailing_settings do |t|
      t.string :name, default: nil
      t.string :email, default: nil

      t.timestamps null: false
    end
  end
end
