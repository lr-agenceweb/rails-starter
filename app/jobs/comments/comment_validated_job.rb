# frozen_string_literal: true

#
# CommentValidated Job
# ========================
class CommentValidatedJob < ApplicationJob
  def perform(comment)
    CommentMailer.comment_validated(comment).deliver_now
  end
end
