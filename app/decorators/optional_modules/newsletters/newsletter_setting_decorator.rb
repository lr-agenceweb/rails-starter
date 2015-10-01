#
# == NewsletterSettingDecorator
#
class NewsletterSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def send_welcome_email_d
    color = model.send_welcome_email? ? 'green' : 'red'
    status_tag_deco I18n.t("#{send_welcome_email}"), color
  end

  def title_subscriber
    raw(model.title_subscriber)
  end

  def content_subscriber
    raw(model.content_subscriber)
  end
end
