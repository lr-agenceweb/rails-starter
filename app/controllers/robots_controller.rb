#
# == RobotsController
#
class RobotsController < ActionController::Base
  skip_before_action :set_optional_modules, :set_adult_validation, :set_menu_elements, :set_background, :set_host_name, :set_newsletter_user, :set_search_autocomplete, :set_slider, :set_socials_network
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
