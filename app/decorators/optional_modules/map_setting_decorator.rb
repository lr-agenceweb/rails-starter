#
# == MapSettingDecorator
#
class MapSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def marker_color_d
    content_tag(:div, '', style: "background-color: #{model.marker_color}; width: 35px; height: 20px;") unless model.marker_color.blank?
  end

  #
  # == Microdatas
  #
  def microdata_meta
    content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/PostalAddress') do
      concat(tag(:meta, itemprop: 'streetAddress', content: model.location.try(:address)))
      concat(tag(:meta, itemprop: 'postalCode', content: model.location.try(:postcode)))
      concat(tag(:meta, itemprop: 'addressLocality', content: model.location.try(:city)))
    end
  end
end
