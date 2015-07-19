#
# == OptionalModuleDecorator
#
class OptionalModuleDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include ApplicationHelper
  delegate_all

  def status
    color = model.enabled? ? 'green' : 'red'
    status_tag_deco(I18n.t("enabled.#{model.enabled}"), color)
  end

  def name
    t("optional_module.name.#{model.name.underscore.downcase}")
  end
end
