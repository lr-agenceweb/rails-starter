class CreateMailingMessageUsers < ActiveRecord::Migration
  def change
    create_table :mailing_message_users do |t|
      t.references :mailing_user, index: true
      t.references :mailing_message, index: true
    end
  end
end
