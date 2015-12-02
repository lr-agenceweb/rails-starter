class CreateAdultSettings < ActiveRecord::Migration
  def up
    create_table :adult_settings do |t|
      t.string :redirect_link
      t.boolean :enabled, default: false

      t.timestamps null: false
    end

    AdultSetting.create_translation_table! title: :string, content: :text
  end

  def down
    drop_table :adult_settings
    AdultSetting.drop_translation_table!
  end
end
