class AddVideoPaperclipToVideoUpload < ActiveRecord::Migration
  def up
    add_attachment :video_uploads, :video_file
  end

  def down
    remove_attachment :video_uploads, :video_file
  end
end
