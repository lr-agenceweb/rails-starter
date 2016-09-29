# frozen_string_literal: true

#
# == SkippableConcern
#
module Skippable
  extend ActiveSupport::Concern

  included do
    skip_before_action :set_host_name,

                       # Core
                       :set_menu_elements,
                       :set_controller_name,
                       :set_categories,
                       :set_current_category,

                       # OptionalModules
                       :set_background,
                       :set_newsletter_user,
                       :set_slider,
                       :set_socials_network,
                       :set_map,
                       :set_adult_validation,
                       :set_legal_notices,

                       # AdminBar
                       :admin_bar_enabled?,
                       :set_comments_count,
                       :set_guest_books_count,
                       :set_module_settings
  end
end
