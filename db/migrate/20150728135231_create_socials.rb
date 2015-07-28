class CreateSocials < ActiveRecord::Migration
  def change
    create_table :socials do |t|
      t.string :title
      t.string :link
      t.string :kind
      t.boolean :enabled, default: true

      t.timestamps null: false
    end
  end
end
