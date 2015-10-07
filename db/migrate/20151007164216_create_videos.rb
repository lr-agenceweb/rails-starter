class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :videoable, polymorphic: true, index: true
      t.string :url
      t.boolean :online, default: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
