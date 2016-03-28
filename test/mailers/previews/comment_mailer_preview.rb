# frozen_string_literal: true
#
# == MailingMessage Mailer preview
# Preview all emails at http://localhost:3000/rails/mailers/comment_preview
#
class CommentMailerPreview < ActionMailer::Preview
  def comment_preview
    @comment = Comment.first
    CommentMailer.send_email(@comment)
  end
end
