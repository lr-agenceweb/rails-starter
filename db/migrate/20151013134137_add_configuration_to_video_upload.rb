class AddConfigurationToVideoUpload < ActiveRecord::Migration
  def change
    add_column :video_uploads, :video_autoplay, :boolean, default: false
    add_column :video_uploads, :video_loop, :boolean, default: false
    add_column :video_uploads, :video_controls, :boolean, default: true
    add_column :video_uploads, :video_mute, :boolean, default: false
  end
end
