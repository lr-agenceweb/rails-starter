# frozen_string_literal: true

#
# == AdultSettingDecorator
#
class AdultSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def title
    model.title if title?
  end

  def content
    raw(model.content) if content?
  end

  def redirect_link
    return Figaro.env.adult_not_validated_popup_redirect_link if model.redirect_link.blank?
    model.redirect_link
  end
end
