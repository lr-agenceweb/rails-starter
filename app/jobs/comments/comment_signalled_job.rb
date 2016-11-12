# frozen_string_literal: true

#
# CommentSignalled Job
# ========================
class CommentSignalledJob < ApplicationJob
  def perform(comment)
    CommentMailer.comment_signalled(comment).deliver_now
  end
end
