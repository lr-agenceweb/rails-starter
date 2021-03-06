# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == MappableConcern
  #
  module Mappable
    extend ActiveSupport::Concern

    included do
      include OptionalModules::MapHelper

      before_action :set_gon_map_setting,
                    if: proc { map_contact? || map_event? }
      before_action :set_map_contact, if: :map_contact?

      decorates_assigned :location, :map_setting

      private

      def set_gon_map_setting
        gon_mapbox_params
      end

      def set_map_contact
        @show_map_contact = true
        gon_location_params
      end

      def map_contact?
        @map_setting = MapSetting.first
        @map_module.enabled? &&
          map_setting.show_map? &&
          map_setting.location? &&
          map_setting.location.decorate.latlon?
      end

      def map_event?
        @map_module.enabled? &&
          EventSetting.first.show_map?
      end
    end
  end
end
