#
# == GuestBookDecorator
#
class GuestBookDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include ApplicationHelper
  delegate_all

  def content
    model.content.html_safe
  end

  def status
    color = model.validated? ? 'green' : 'orange'
    status_tag_deco(I18n.t("validate.#{model.validated}"), color)
  end

  # def validated
  #   link = link_to 'Toggle', toggle_guest_book_validated_path(model), data: { confirm: 'Voulez vous changer le statut de ce message ?' }
  #   html = ''
  #   arbre do
  #     html << status_tag("#{model.validated}", (model.validated? ? :ok : :warn))
  #   end
  #   html << content_tag(:p, link)
  #   html.html_safe
  # end
end
