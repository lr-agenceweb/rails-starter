#
# == NewsletterDecorator
#
class NewsletterDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include ApplicationHelper
  delegate_all

  def title
    model.title if title?
  end

  def preview
    raw newsletter_preview(model.id)
  end

  def sent_at
    model.sent_at_message
  end

  def send_link
    render 'send', resource: model
  end

  def status
    color = model.already_sent? ? 'red' : 'green'
    status_tag_deco(I18n.t("sent.#{model.already_sent?}"), color)
  end
end
