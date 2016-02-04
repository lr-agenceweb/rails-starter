#
# == MappableConcern
#
module Mappable
  extend ActiveSupport::Concern

  included do
    include MapHelper
    before_action :set_map, if: proc { @map_module.enabled? && setting.show_map? && setting.location? && setting.location.decorate.latlon? }
    decorates_assigned :location

    private

    def set_map
      @location = setting.location
      mapbox_gon_params
    end
  end
end
