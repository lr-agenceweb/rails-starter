class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, limit: 50, default: ''
      t.string :username
      t.string :email
      t.text :comment
      t.string :lang
      t.boolean :validated, default: false
      t.references :commentable, polymorphic: true
      t.references :user, index: true
      t.string :role, default: 'comments'

      t.timestamps null: false
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
  end

  def self.down
    drop_table :comments
  end
end
