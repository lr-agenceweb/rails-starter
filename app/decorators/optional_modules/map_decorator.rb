#
# == MapDecorator
#
class MapDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
  decorates_association :location

  def map(map_module_enabled, force = false, from_form = false)
    raw content_tag(:div, nil, class: "map dark #{from_form ? 'from-form' : '' }", id: 'map') if map_module_enabled && !model.location.nil? && ((model.show_map && model.location.decorate.latlon?) || (force && model.location.decorate.latlon?))
  end

  #
  # == Location
  #
  def full_address_inline
    model.location.decorate.full_address_inline
  end

  def status
    color = model.show_map? ? 'green' : 'red'
    status_tag_deco I18n.t("map.#{model.show_map}"), color
  end

  def marker_color_deco
    content_tag(:div, '', style: "background-color: #{model.marker_color}; width: 35px; height: 20px;") unless model.marker_color.blank?
  end

  #
  # == ActiveAdmin
  #
  def title_aa_show
    I18n.t('activerecord.models.map.one')
  end

  #
  # Microdatas
  #
  def microdata_meta
    content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/PostalAddress') do
      concat(tag(:meta, itemprop: 'streetAddress', content: model.location.try(:address)))
      concat(tag(:meta, itemprop: 'postalCode', content: model.location.try(:postcode)))
      concat(tag(:meta, itemprop: 'addressLocality', content: model.location.try(:city)))
    end
  end
end
