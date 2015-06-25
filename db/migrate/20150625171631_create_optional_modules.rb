class CreateOptionalModules < ActiveRecord::Migration
  def change
    create_table :optional_modules do |t|
      t.string :name
      t.boolean :enabled, default: false

      t.timestamps null: false
    end
  end
end
