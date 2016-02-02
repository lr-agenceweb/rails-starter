class CreateMailingSettings < ActiveRecord::Migration
  def up
    create_table :mailing_settings do |t|
      t.string :name, default: nil
      t.string :email, default: nil
      t.text :signature
      t.string :unsubscribe_title
      t.text :unsubscribe_content

      t.timestamps null: false
    end

    MailingSetting.create_translation_table! signature: :text, unsubscribe_title: :string, unsubscribe_content: :text
  end

  def down
    drop_table :mailing_settings
    MailingSetting.drop_translation_table!
  end
end
