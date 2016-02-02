class CreateVideoUploads < ActiveRecord::Migration
  def change
    create_table :video_uploads do |t|
      t.references :videoable, polymorphic: true, index: true
      t.boolean :online, default: true
      t.boolean :video_autoplay, default: false
      t.boolean :video_loop, default: false
      t.boolean :video_controls, default: true
      t.boolean :video_mute, default: false
      t.integer :position
      t.boolean :video_file_processing, default: true
      t.text :retina_dimensions

      t.timestamps null: false
    end
  end
end
