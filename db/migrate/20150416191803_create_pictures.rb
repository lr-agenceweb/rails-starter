class CreatePictures < ActiveRecord::Migration
  def up
    create_table :pictures do |t|
      t.references :attachable, polymorphic: true, index: true
      t.attachment :image
      t.string :title
      t.text :description
      t.text :retina_dimensions
      t.boolean :primary, default: false
      t.boolean :online, default: true

      t.timestamps null: false
    end

    Picture.create_translation_table! title: :string, description: :text
  end

  def down
    drop_table :pictures
    Picture.drop_translation_table!
  end
end
