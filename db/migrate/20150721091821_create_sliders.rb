class CreateSliders < ActiveRecord::Migration
  def change
    create_table :sliders do |t|
      t.string :animate
      t.boolean :autoplay, default: true
      t.integer :timeout, default: 5000
      t.boolean :hover_pause, default: true
      t.boolean :loop, default: true
      t.boolean :navigation, default: false
      t.boolean :bullet, default: false
      t.boolean :online, default: true
      t.references :category, index: true, unique: true

      t.timestamps null: false
    end
  end
end
