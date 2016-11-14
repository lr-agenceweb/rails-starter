# frozen_string_literal: true

#
# == GuestBookDecorator
#
class GuestBookDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include ApplicationHelper
  delegate_all
end
