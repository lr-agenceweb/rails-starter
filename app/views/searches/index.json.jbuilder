# frozen_string_literal: true

json.array! @searches do |search|
  # Core
  json.title search.title
  json.url resource_route_show(search.object)
  json.page t("activerecord.models.#{search.object.class.name.underscore}.other")

  # Assets
  json.picture search.picture.image.url(:thumb) if search.pictures?
end
