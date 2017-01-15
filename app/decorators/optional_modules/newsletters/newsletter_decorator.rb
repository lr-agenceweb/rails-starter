# frozen_string_literal: true

#
# NewsletterDecorator
# =====================
class NewsletterDecorator < MailerDecorator
  include Draper::LazyHelpers
  delegate_all

  def list_subscribers
    render '/admin/newsletters/list_subscribers', newsletter_users: NewsletterUser.all
  end
end
