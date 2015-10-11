class RenameVideoToVideoPlatform < ActiveRecord::Migration
  def change
    rename_table :videos, :video_platforms
  end
end
