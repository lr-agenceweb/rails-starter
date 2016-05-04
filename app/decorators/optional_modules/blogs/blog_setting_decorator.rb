# frozen_string_literal: true

#
# == BlogSettingDecorator
#
class BlogSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
