class CreateHeadings < ActiveRecord::Migration
  def up
    create_table :headings do |t|
      t.text :content
      t.references :headingable, index: true, polymorphic: true

      t.timestamps null: false
    end

    Heading.create_translation_table! content: :text
  end

  def down
    drop_table :headings
    Heading.drop_translation_table!
  end
end
