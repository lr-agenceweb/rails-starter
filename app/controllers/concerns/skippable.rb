# frozen_string_literal: true
#
# == SkippableConcern
#
module Skippable
  extend ActiveSupport::Concern

  included do
    skip_before_action :set_adult_validation,
                       :set_menu_elements,
                       :set_background,
                       :set_host_name,
                       :set_newsletter_user,
                       :set_slider,
                       :set_socials_network,
                       :set_map
  end
end
