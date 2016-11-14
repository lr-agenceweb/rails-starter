# frozen_string_literal: true

#
# == NewsletterSettingDecorator
#
class NewsletterSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == Content
  #
  def title_subscriber
    safe_join [raw(model.title_subscriber)]
  end

  def content_subscriber
    safe_join [raw(model.content_subscriber)]
  end

  def newsletter_user_roles_list
    model.newsletter_user_roles.map(&:title)
  end
end
