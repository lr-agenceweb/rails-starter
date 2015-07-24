class CreateSlides < ActiveRecord::Migration
  def up
    create_table :slides do |t|
      t.references :attachable, polymorphic: true, index: true
      t.attachment :image
      t.string :title
      t.text :description
      t.text :retina_dimensions
      t.boolean :primary, default: false
      t.boolean :online, default: true

      t.timestamps null: false
    end

    Slide.create_translation_table! title: :string, description: :text
  end

  def down
    drop_table :slides
    Slide.drop_translation_table!
  end
end
