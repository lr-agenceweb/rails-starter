#
# == Comment Job
#
class CommentJob < ActiveJob::Base
  queue_as :default

  def perform(comment)
    CommentMailer.send_email(comment).deliver_now
  end
end
