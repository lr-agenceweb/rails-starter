#
# == CommentSettingDecorator
#
class CommentSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def should_validate
    color = model.should_validate? ? 'green' : 'red'
    status_tag_deco I18n.t(model.should_validate?.to_s), color
  end

  def should_signal
    color = model.should_signal? ? 'green' : 'red'
    status_tag_deco I18n.t(model.should_signal?.to_s), color
  end

  def send_email
    color = model.send_email? ? 'green' : 'red'
    status_tag_deco I18n.t(model.send_email?.to_s), color
  end
end
