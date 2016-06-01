# frozen_string_literal: true

#
# == CommentValidated Job
#
class CommentValidatedJob < ActiveJob::Base
  queue_as :default

  def perform(comment)
    CommentMailer.send_validated_comment(comment).deliver_now
  end
end
