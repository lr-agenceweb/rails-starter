# frozen_string_literal: true
#
# == ConnectionDecorator
#
class ConnectionDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all

  def link
    link_to model.link.url, model.link.url, target: :blank if link?
  end

  private

  def link?
    model.link.try(:url).present?
  end
end
