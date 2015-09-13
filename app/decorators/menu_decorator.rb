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
    I18n.t('menu.title_aa_show', menu_item: model.title)
  end

  def children_list
    if model.has_children?
      model.children.map(&:title).join(', ')
    else
      I18n.t('menu.no_children')
    end
  end

  def show_in_footer_d
    color = show_in_footer? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{show_in_footer}"), color
  end

  def title_sortable_tree
    "#{model.title} #{status}"
  end
end
