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

  def title_for_category(category)
    link = link_to category.title, category.menu_link(category.name), class: 'l-page-title-link'
    content_tag(:h2, link, class: 'l-page-title', id: category.name.downcase)
  end

  def background_from_color_picker(category)
    "background-color: #{category.color}" unless category.nil? || category.color.blank?
  end
end
