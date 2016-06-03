# frozen_string_literal: true

#
# == CommentCreated Job
#
class CommentCreatedJob < ActiveJob::Base
  queue_as :default

  def perform(comment)
    CommentMailer.comment_created(comment).deliver_now
  end
end
