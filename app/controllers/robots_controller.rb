# frozen_string_literal: true

#
# == RobotsController
#
class RobotsController < ActionController::Base
  include Skippable

  layout false

  def index
    expires_in 12.hours, public: true

    if Rails.env.production?
      render 'allow'
    else
      render 'disallow'
    end
  end
end
