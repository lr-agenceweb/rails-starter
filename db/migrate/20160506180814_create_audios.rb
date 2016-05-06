class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.references :audioable, polymorphic: true, index: true
      t.attachment :audio
      t.boolean :online

      t.timestamps null: false
    end
  end
end
