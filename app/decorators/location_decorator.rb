# frozen_string_literal: true

#
# == LocationDecorator
#
class LocationDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def full_address(inline = true)
    html = []
    html << content_tag(:span) do
      concat(safe_join([raw(model.address + (inline ? ', ' : '<br />')).to_s])) if address?
      concat((model.postcode + ' - ')) if postcode?
      concat(model.city) if city?
    end
    safe_join [html]
  end

  #
  # == Popup
  #
  def address_popup
    html = []
    html << content_tag(:div) do
      concat content_tag(:p, full_address)
    end
    safe_join [html]
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
