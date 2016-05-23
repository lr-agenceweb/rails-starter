# frozen_string_literal: true

#
# == BackgroundDecorator
#
class BackgroundDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def category_name
    model.attachable.menu_title
  end

  #
  # ActiveAdmin
  #
  def title_aa_show
    "#{I18n.t('activerecord.models.background.one')} lié à la page \"#{category_name}\""
  end

  def title_aa_edit
    "#{t('active_admin.edit')} #{I18n.t('activerecord.models.background.one')} page \"#{category_name}\""
  end
end
