class AddSignatureToMailingSetting < ActiveRecord::Migration
  def up
    add_column :mailing_settings, :signature, :text, after: :email
    MailingSetting.create_translation_table! signature: :text
  end

  def down
    remove_column :mailing_settings, :signature
    MailingSetting.drop_translation_table!
  end
end
