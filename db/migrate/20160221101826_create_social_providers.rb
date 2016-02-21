class CreateSocialProviders < ActiveRecord::Migration
  def change
    create_table :social_providers do |t|
      t.string :name
      t.boolean :enabled, default: true
      t.references :social_connect_setting, index: true

      t.timestamps null: false
    end
  end
end
