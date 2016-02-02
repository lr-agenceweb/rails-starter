class CreateVideoPlatforms < ActiveRecord::Migration
  def up
    create_table :video_platforms do |t|
      t.references :videoable, polymorphic: true, index: true
      t.string :url
      t.boolean :native_informations, default: false
      t.boolean :online, default: true
      t.integer :position

      t.timestamps null: false
    end
    VideoPlatform.create_translation_table! title: :string, description: :text
  end

  def down
    drop_table :video_platforms
    VideoPlatform.drop_translation_table!
  end
end
