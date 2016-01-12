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

  def show_in_header_d
    color = show_in_header? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{show_in_header}"), color
  end

  def show_in_footer_d
    color = show_in_footer? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{show_in_footer}"), color
  end
end
