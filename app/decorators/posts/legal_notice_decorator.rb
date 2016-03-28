# frozen_string_literal: true
#
# == LegalNotice Decorator
#
class LegalNoticeDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all
end
