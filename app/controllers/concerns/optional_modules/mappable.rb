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

      before_action :set_map_setting, if: proc { set_map? }
      before_action :set_map, if: proc { set_map? }
      decorates_assigned :location

      private

      def set_map
        @location = setting.location
        mapbox_gon_params
      end

      def set_map_setting
        @map_setting = MapSetting.first
        mapbox_gon_params
      end

      def set_map?
        @map_module.enabled? &&
          setting.show_map? &&
          setting.location? &&
          setting.location.decorate.latlon?
      end
    end
  end
end
