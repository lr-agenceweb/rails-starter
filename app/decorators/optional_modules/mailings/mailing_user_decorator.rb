#
# == MailingUserDecorator
#
class MailingUserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def archive_status
    color = model.archive? ? 'blue' : 'warning'
    status_tag_deco I18n.t("archive.#{model.archive}"), color
  end
end
