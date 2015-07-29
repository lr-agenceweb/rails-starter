class CreateBackgrounds < ActiveRecord::Migration
  def change
    create_table :backgrounds do |t|
      t.references :attachable, polymorphic: true, index: true
      t.attachment :image
      t.text :retina_dimensions

      t.timestamps null: false
    end
  end
end
