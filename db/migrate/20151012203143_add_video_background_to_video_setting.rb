class AddVideoBackgroundToVideoSetting < ActiveRecord::Migration
  def change
    add_column :video_settings, :video_background, :boolean, after: :video_upload, default: false
  end
end
