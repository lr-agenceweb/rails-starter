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

  def validated
    link = link_to 'Toggle', toggle_guest_book_validated_path(model), data: { confirm: 'Voulez vous changer le statut de ce message ?' }
    html = ''
    arbre do
      html << status_tag("#{model.validated}", (model.validated? ? :ok : :warn))
    end
    html << content_tag(:p, link)
    html.html_safe
  end

  def created_at
    I18n.l(model.created_at, format: :long)
  end
end
