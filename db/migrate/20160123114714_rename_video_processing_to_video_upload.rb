class RenameVideoProcessingToVideoUpload < ActiveRecord::Migration
  def change
    rename_column :video_uploads, :video_processing, :video_file_processing
  end
end
