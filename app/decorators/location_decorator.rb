#
# == LocationDecorator
#
class LocationDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def full_address_inline
    content_tag(:span) do
      concat(model.address + ', ') if address?
      concat(model.postcode.to_s + ' - ') if postcode?
      concat(model.city) if city?
    end
  end

  def latlon?
    !model.latitude.nil? && !model.longitude.nil?
  end

  private

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
