class CreateBlogSettings < ActiveRecord::Migration
  def change
    create_table :blog_settings do |t|
      t.boolean :prev_next, default: false

      t.timestamps null: false
    end
  end
end
