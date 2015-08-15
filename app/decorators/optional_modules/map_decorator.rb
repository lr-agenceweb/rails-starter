#
# == MapDecorator
#
class MapDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def latlon
    simple_format("#{model.latitude}, #{model.longitude}")
  end

  def map(map_module_enabled, force = false, from_form = false)
    raw content_tag(:div, nil, class: "map dark #{from_form ? 'from-form' : '' }", id: 'map') if map_module_enabled && ((model.show_map && latlon?) || (force && latlon?))
  end

  def full_address
    simple_format("#{model.address} <br> #{model.postcode} - #{model.city}")
  end

  def status
    color = model.show_map? ? 'green' : 'red'
    status_tag_deco I18n.t("map.#{model.show_map}"), color
  end

  def marker_color_deco
    content_tag(:div, '', style: "background-color: #{model.marker_color}; width: 35px; height: 20px;") unless model.marker_color.blank?
  end

  def title_aa_show
    I18n.t('activerecord.models.map.one')
  end

  #
  # Microdatas
  #
  def microdata_meta
    content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/PostalAddress') do
      concat(tag(:meta, itemprop: 'streetAddress', content: model.address))
      concat(tag(:meta, itemprop: 'postalCode', content: model.postcode))
      concat(tag(:meta, itemprop: 'addressLocality', content: model.city))
    end
  end

  private

  def latlon?
    !model.latitude.nil? && !model.longitude.nil?
  end
end
