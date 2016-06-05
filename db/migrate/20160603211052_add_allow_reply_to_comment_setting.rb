class AddAllowReplyToCommentSetting < ActiveRecord::Migration
  def change
    add_column :comment_settings, :allow_reply, :boolean, default: true, after: :should_validate
  end
end
