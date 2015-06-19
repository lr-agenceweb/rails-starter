#
# == RobotsController
#
class RobotsController < ApplicationController
  layout false

  def index
    expires_in 12.hours, public: true

    if Rails.env.production?
      render 'disallow'
    else
      render 'allow'
    end
  end
end
