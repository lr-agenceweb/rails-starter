# frozen_string_literal: true

#
# MailingUser Decorator
# =======================
class MailingUserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def name
    html = []
    html << email
    html << content_tag(:small, "(#{fullname})")
    html << lang
    safe_join [html], ' '
  end

  def name_or_not
    model.fullname.blank? ? ',' : ' ' + model.fullname + ','
  end

  def archive_status
    color = model.archive? ? 'blue' : 'warning'
    status_tag_deco I18n.t("archive.#{model.archive}"), color
  end
end
