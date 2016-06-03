# frozen_string_literal: true

#
# == CommentSignalled Job
#
class CommentSignalledJob < ActiveJob::Base
  queue_as :default

  def perform(comment)
    CommentMailer.comment_signalled(comment).deliver_now
  end
end
