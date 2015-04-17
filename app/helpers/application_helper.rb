#
# == ApplicationHelper
#
module ApplicationHelper
  def current_year
    Time.zone.now.year
  end

  def gon_params
    gon.push(
      mapbox_username: Figaro.env.mapbox_username,
      mapbox_key: Figaro.env.mapbox_map_key,
      mapbox_access_token: Figaro.env.mapbox_access_token,
      name: @setting.name,
      subtitle: @setting.subtitle,
      address: @setting.address,
      city: @setting.city,
      postcode: @setting.postcode,
      latitude: @setting.latitude,
      longitude: @setting.longitude
    )
  end
end
