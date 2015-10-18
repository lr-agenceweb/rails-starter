class CreateVideoUploads < ActiveRecord::Migration
  def change
    create_table :video_uploads do |t|
      t.references :videoable, polymorphic: true, index: true
      t.boolean :online, default: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
