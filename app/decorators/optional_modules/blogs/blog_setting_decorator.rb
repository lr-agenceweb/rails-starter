#
# == BlogSettingDecorator
#
class BlogSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def prev_next
    color = model.prev_next? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.prev_next}"), color
  end
end
