class CreateVideoSettings < ActiveRecord::Migration
  def change
    create_table :video_settings do |t|
      t.boolean :video_platform, default: true
      t.boolean :video_upload, default: true

      t.timestamps null: false
    end
  end
end
