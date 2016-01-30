class CreateCommentSettings < ActiveRecord::Migration
  def change
    create_table :comment_settings do |t|
      t.boolean :should_signal, default: true
      t.boolean :send_email, default: false

      t.timestamps null: false
    end
  end
end
