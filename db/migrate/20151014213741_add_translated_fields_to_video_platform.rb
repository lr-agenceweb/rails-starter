class AddTranslatedFieldsToVideoPlatform < ActiveRecord::Migration
  def up
    add_column :video_platforms, :native_informations, :boolean, default: false, after: :url
    VideoPlatform.create_translation_table! title: :string, description: :text
  end

  def down
    remove_column :video_platforms, :native_informations
    VideoPlatform.drop_translation_table!
  end
end
