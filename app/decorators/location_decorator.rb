# frozen_string_literal: true

#
# == LocationDecorator
#
class LocationDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def full_address(inline = true)
    content_tag(:span) do
      concat(raw(model.address + (inline ? ', ' : '<br />')).to_s) if address?
      concat(model.postcode + ' - ') if postcode?
      concat(model.city) if city?
    end
  end

  #
  # == Popup
  #
  def address_popup
    h.content_tag(:div) do
      concat(h.content_tag(:p, full_address))
    end
  end

  #
  # == Boolean
  #
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
