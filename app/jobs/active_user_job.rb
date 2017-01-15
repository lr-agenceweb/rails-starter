# frozen_string_literal: true

#
# ActiveUser Job
# ================
class ActiveUserJob < ApplicationJob
  def perform(user)
    ActiveUserMailer.send_email(user).deliver_now
  end
end
