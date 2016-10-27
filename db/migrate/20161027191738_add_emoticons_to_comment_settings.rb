class AddEmoticonsToCommentSettings < ActiveRecord::Migration
  def change
    add_column :comment_settings, :emoticons, :boolean, after: :allow_reply, default: false
  end
end
