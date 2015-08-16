#
# == MappableConcern
#
module Mappable
  extend ActiveSupport::Concern

  included do
    before_action :set_map, if: proc { @map_module.enabled? }
    decorates_assigned :map

    private

    def set_map
      @map = Map.first
      mapbox_gon_params if !map.nil? && map.show_map?
    end
  end
end
