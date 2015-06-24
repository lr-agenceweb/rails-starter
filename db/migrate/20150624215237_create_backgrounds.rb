class CreateBackgrounds < ActiveRecord::Migration
  def change
    create_table :backgrounds do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.attachment :image
      t.text :retina_dimensions

      t.timestamps null: false
    end
  end
end
