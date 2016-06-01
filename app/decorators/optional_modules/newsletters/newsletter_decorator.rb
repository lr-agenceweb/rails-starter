# frozen_string_literal: true

#
# == NewsletterDecorator
#
class NewsletterDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == Content
  #
  def title
    model.title if title?
  end

  def sent_at
    model.sent_at_message
  end

  def preview
    html = ''
    I18n.available_locales.each do |locale|
      html += link_to I18n.t("active_admin.globalize.language.#{locale}"), send("preview_admin_newsletter_#{locale}_path", model.id), target: :_blank
      html += '<br/>'
    end
    html.html_safe
  end

  def live_preview
    render '/admin/newsletters/iframe_preview', resource: model
  end

  def send_link
    render '/admin/newsletters/send', resource: model
  end

  def list_subscribers
    render '/admin/newsletters/list_subscribers', newsletter_users: NewsletterUser.all
  end

  #
  # == Status tag
  #
  def status
    color = model.already_sent? ? 'red' : 'green'
    status_tag_deco(I18n.t("sent.#{model.already_sent?}"), color)
  end
end
