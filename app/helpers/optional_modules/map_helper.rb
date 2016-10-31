# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == MapHelper
  #
  module MapHelper
    def gon_mapbox_params
      gon.push(
        mapbox_username: Figaro.env.mapbox_username,
        mapbox_key: Figaro.env.mapbox_map_key,
        mapbox_access_token: Figaro.env.mapbox_access_token
      )
    end

    def gon_location_params
      gon.push(
        latitude: @location.try(:latitude),
        longitude: @location.try(:longitude),
        marker_icon: @map_setting.marker_icon,
        marker_color: @map_setting.marker_color,
        root_url: I18n.with_locale(@language) { root_path }
      )
    end
  end
end
