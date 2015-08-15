#
# == MapHelper
#
module MapHelper
  def mapbox_gon_params
    gon.push(
      mapbox_username: Figaro.env.mapbox_username,
      mapbox_key: Figaro.env.mapbox_map_key,
      mapbox_access_token: Figaro.env.mapbox_access_token,
      logo: @setting.decorate.logo_deco,
      name: @setting.title,
      subtitle: @setting.subtitle,
      address: @map.location.try(:address),
      city: @map.location.try(:city),
      postcode: @map.location.try(:postcode),
      latitude: @map.location.try(:latitude),
      longitude: @map.location.try(:longitude),
      marker_icon: @map.marker_icon.nil? ? '' : @map.marker_icon,
      marker_color: @map.marker_color,
      root_url: root_path(locale: @language)
    )
  end
end
