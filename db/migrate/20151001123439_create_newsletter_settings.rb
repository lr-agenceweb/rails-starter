class CreateNewsletterSettings < ActiveRecord::Migration
  def up
    create_table :newsletter_settings do |t|
      t.boolean :send_welcome_email, default: true
      t.string :title_subscriber
      t.text :content_subscriber

      t.timestamps null: false
    end

    NewsletterSetting.create_translation_table! title_subscriber: :string, content_subscriber: :text
  end

  def down
    drop_table :newsletter_settings
    NewsletterSetting.drop_translation_table!
  end
end
