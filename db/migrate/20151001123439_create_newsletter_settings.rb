class CreateNewsletterSettings < ActiveRecord::Migration
  def change
    create_table :newsletter_settings do |t|

      t.timestamps null: false
    end
  end
end
