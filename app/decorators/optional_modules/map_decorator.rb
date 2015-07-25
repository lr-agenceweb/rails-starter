#
# == MapDecorator
#
class MapDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def latlon
    simple_format("#{model.latitude}, #{model.longitude}")
  end

  def map(map_module_enabled, force = false)
    raw content_tag(:div, nil, class: 'map dark', id: 'map') if map_module_enabled && ((model.show_map && latlon?) || (force && latlon?))
  end

  def full_address
    simple_format("#{model.address} <br> #{model.postcode} - #{model.city}")
  end

  def status
    color = model.show_map? ? 'green' : 'red'
    status_tag_deco I18n.t("map.#{model.show_map}"), color
  end

  private

  def latlon?
    !model.latitude.nil? && !model.longitude.nil?
  end
end
