class CreateReferencements < ActiveRecord::Migration
  def up
    create_table :referencements do |t|
      t.references :attachable, polymorphic: true, index: true
      t.string :title
      t.text :description
      t.string :keywords

      t.timestamps null: false
    end

    Referencement.create_translation_table! title: :string, description: :text, keywords: :string
  end

  def down
    drop_table :referencements
    Referencement.drop_translation_table!
  end
end
