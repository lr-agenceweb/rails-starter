class CreateSocialConnectSettings < ActiveRecord::Migration
  def change
    create_table :social_connect_settings do |t|
      t.boolean :enabled, default: true

      t.timestamps null: false
    end
  end
end
