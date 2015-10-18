class AddTranslatedFieldsToVideoUpload < ActiveRecord::Migration
  def up
    VideoUpload.create_translation_table! title: :string, description: :text
  end

  def down
    VideoUpload.drop_translation_table!
  end
end
