class AddAttachmentAvatarToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      add_attachment :users, :avatar
      add_column :users, :retina_dimensions, :text, after: :email
    end
  end

  def self.down
    remove_attachment :users, :avatar
    remove_column :users, :retina_dimensions, :text
  end
end
