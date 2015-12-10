class CreateMailingUsers < ActiveRecord::Migration
  def change
    create_table :mailing_users do |t|
      t.string :fullname
      t.string :email
      t.string :token
      t.string :lang
      t.boolean :archive, default: false

      t.timestamps null: false
    end
  end
end
