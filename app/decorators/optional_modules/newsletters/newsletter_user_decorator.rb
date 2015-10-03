#
# == NewsletterUserDecorator
#
class NewsletterUserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def role_status
    color = 'orange' if tester?
    color = 'green' if subscriber?

    arbre do
      Globalize.with_locale(:en) do
        status_tag I18n.t("role.#{model.newsletter_user_role_title}"), color
      end
    end
  end

  def tester?
    model.newsletter_user_role_title == 'testeur'
  end

  def subscriber?
    model.newsletter_user_role_title == 'abonné'
  end
end
