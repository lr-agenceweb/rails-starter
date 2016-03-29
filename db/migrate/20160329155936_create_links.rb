class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :linkable, index: true, polymorphic: true
      t.string :url

      t.timestamps null: false
    end
  end
end
