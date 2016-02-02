class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.string :title, limit: 50, default: ''
      t.string :username
      t.string :email
      t.text :comment
      t.string :token
      t.string :lang
      t.boolean :validated, default: false
      t.boolean :signalled, default: false
      t.string :ancestry, index: true
      t.references :user, index: true
      t.string :role, default: 'comments'

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :comments
  end
end
