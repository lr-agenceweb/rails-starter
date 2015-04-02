class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :name
      t.string :title
      t.string :subtitle
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :postcode
      t.string :geocode_address
      t.float :latitude
      t.float :longitude
      t.boolean :show_map, default: true

      t.timestamps
    end
    Setting.create_translation_table! title: :string, subtitle: :string
  end

  def down
    drop_table :settings
    Setting.drop_translation_table!
  end
end
