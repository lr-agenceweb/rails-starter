class AddShouldValidateToCommentSetting < ActiveRecord::Migration
  def change
    add_column :comment_settings, :should_validate, :boolean, default: true, after: :send_email
  end
end
