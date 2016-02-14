#
# == GuestBookSettingDecorator
#
class GuestBookSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def should_validate
    color = model.should_validate? ? 'green' : 'red'
    status_tag_deco I18n.t(model.should_validate?.to_s), color
  end
end
