class CreateMailingSettings < ActiveRecord::Migration
  def change
    create_table :mailing_settings do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
