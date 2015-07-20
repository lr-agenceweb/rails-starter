#
# == NewsletterUserDecorator
#
class NewsletterUserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def role
    color = 'orange' if tester?
    color = 'green' if subscriber?

    arbre do
      status_tag I18n.t("role.#{model.role}"), color
    end
  end

  def tester?
    model.role == 'tester'
  end

  def subscriber?
    model.role == 'subscriber'
  end
end
