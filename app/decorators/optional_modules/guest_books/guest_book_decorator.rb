# frozen_string_literal: true

#
# == GuestBookDecorator
#
class GuestBookDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include ApplicationHelper
  delegate_all

  def content
    safe_join [raw(model.content)] if content?
  end
end
