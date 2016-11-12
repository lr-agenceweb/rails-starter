# frozen_string_literal: true

#
# CommentCreated Job
# ======================
class CommentCreatedJob < ApplicationJob
  def perform(comment)
    CommentMailer.comment_created(comment).deliver_now
  end
end
