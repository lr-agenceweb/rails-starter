# frozen_string_literal: true

#
# == LocationDecorator
#
class LocationDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def full_address_inline
    content_tag(:span) do
      concat(model.address + ', ') if address?
      concat(model.postcode + ' - ') if postcode?
      concat(model.city) if city?
    end
  end

  #
  # == Popup
  #
  def title_popup(setting)
    content_tag(:a, href: root_path, class: 'logo-link') do
      concat(setting.logo_deco)
      concat(content_tag(:h3, class: 'marker-title popup-title text-center') do
        concat(setting.title)
        concat(content_tag(:span, class: 'popup-subtitle') do
          concat(setting.subtitle)
        end)
      end)
    end
  end

  def address_popup
    h.content_tag(:div) do
      concat(h.content_tag(:p, full_address_inline))
    end
  end

  #
  # == Boolean
  #
  def latlon?
    !model.latitude.nil? && !model.longitude.nil?
  end

  def address?
    !model.address.blank?
  end

  def postcode?
    !model.postcode.blank?
  end

  def city?
    !model.city.blank?
  end
end
