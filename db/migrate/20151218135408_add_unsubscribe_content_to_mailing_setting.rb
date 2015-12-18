class AddUnsubscribeContentToMailingSetting < ActiveRecord::Migration
  def change
    add_column :mailing_settings, :unsubscribe_title, :string, after: :signature
    add_column :mailing_settings, :unsubscribe_content, :text, after: :unsubscribe_title

    add_column :mailing_setting_translations, :unsubscribe_title, :string
    add_column :mailing_setting_translations, :unsubscribe_content, :text
  end
end
