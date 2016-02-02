class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :title
      t.string :slug, index: true, unique: true
      t.text :content
      t.string :url
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :show_as_gallery, default: false
      t.boolean :show_calendar, default: false
      t.boolean :online, default: true
      t.boolean :prev_next, default: true

      t.timestamps null: false
    end

    Event.create_translation_table! title: :string, slug: :string, content: :text
  end

  def down
    drop_table :events
    Event.drop_translation_table!
  end
end
