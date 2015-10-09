class CreateVideoSubtitles < ActiveRecord::Migration
  def change
    create_table :video_subtitles do |t|
      t.references :subtitleable, polymorphic: true, index: true
      t.boolean :online, default: true

      t.timestamps null: false
    end
  end
end
