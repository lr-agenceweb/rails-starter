class AddAttachmentAvatarToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      # t.attachment :avatar, after: :email
      add_column :users, :retina_dimensions, :text, after: :avatar_file_name
    end
  end

  def self.down
    remove_attachment :users, :avatar
    remove_column :users, :retina_dimensions, :text
  end
end
