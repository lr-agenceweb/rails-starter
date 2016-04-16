# frozen_string_literal: true
#
# == MapSettingDecorator
#
class MapSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def marker_color_d
    content_tag(:div, '', style: "background-color: #{model.marker_color}; width: 35px; height: 20px;") unless model.marker_color.blank?
  end
end
