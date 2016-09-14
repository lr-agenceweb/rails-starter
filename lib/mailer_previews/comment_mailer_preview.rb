# frozen_string_literal: true

#
# == MailingMessage Mailer preview
# Preview all emails at http://localhost:3000/rails/mailers/comment_preview
#
class CommentMailerPreview < ActionMailer::Preview
  # Comment created
  def comment_created_preview
    @comment = Comment.first
    CommentMailer.comment_created(@comment)
  end

  # Comment signalled
  def comment_signalled_preview
    @comment = Comment.first
    CommentMailer.comment_signalled(@comment)
  end

  # Comment validated
  def comment_validated_preview
    @comment = Comment.first
    CommentMailer.comment_validated(@comment)
  end
end
