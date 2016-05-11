# frozen_string_literal: true

#
# == ActiveUser Job
#
class ActiveUserJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    ActiveUserMailer.send_email(user).deliver_now
  end
end
