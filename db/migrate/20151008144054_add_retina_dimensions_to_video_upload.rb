class AddRetinaDimensionsToVideoUpload < ActiveRecord::Migration
  def change
    add_column :video_uploads, :retina_dimensions, :text
  end
end
