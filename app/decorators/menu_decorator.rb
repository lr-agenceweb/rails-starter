#
# == MenuDecorator
#
class MenuDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # ActiveAdmin
  #
  def title_aa_show
    I18n.t('menu.title_aa_show', menu_item: resource.title)
  end

  def children_list
    if resource.has_children?
      resource.children.map(&:title).join(', ')
    else
      I18n.t('menu.no_children')
    end
  end

  def show_in_footer_d
    color = show_in_footer? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{show_in_footer}"), color
  end
end
