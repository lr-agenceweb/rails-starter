class CreateMailingMessages < ActiveRecord::Migration
  def up
    create_table :mailing_messages do |t|
      t.string :title
      t.text :content
      t.datetime :sent_at
      t.string :token

      t.timestamps null: false
    end

    MailingMessage.create_translation_table! title: :string, content: :text
  end

  def down
    drop_table :mailing_messages
    MailingMessage.drop_translation_table!
  end
end
