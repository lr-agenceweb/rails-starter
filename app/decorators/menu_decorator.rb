#
# == MenuDecorator
#
class MenuDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == ActiveAdmin
  #
  def title_aa_show
    I18n.t('menu.title_aa_show', menu_item: model.title)
  end
end
