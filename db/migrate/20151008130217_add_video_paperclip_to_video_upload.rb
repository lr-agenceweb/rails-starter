class AddVideoPaperclipToVideoUpload < ActiveRecord::Migration
  def up
    add_attachment :video_uploads, :video
  end

  def down
    remove_attachment :video_uploads, :video
  end
end
