# frozen_string_literal: true

#
# == RobotsController
#
class RobotsController < ActionController::Base
  include Skippable

  layout false

  def index
    expires_in 12.hours, public: true
    renv = Rails.env.development? ? '' : Rails.env
    @application_host = ENV["application_host_#{renv}"]

    if Rails.env.production?
      render 'allow'
    else
      render 'disallow'
    end
  end
end
