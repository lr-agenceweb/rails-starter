#
# == CommentSettingDecorator
#
class CommentSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def should_signal
    color = model.should_signal? ? 'green' : 'red'
    status_tag_deco I18n.t("#{model.should_signal?}"), color
  end

  def send_email
    color = model.send_email? ? 'green' : 'red'
    status_tag_deco I18n.t("#{model.send_email?}"), color
  end
end
