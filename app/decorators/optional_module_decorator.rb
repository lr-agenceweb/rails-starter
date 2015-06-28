#
# == OptionalModuleDecorator
#
class OptionalModuleDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include ApplicationHelper
  delegate_all

  def status
    color = model.enabled? ? 'green' : 'red'

    arbre do
      status_tag(I18n.t("enabled.#{model.enabled}"), color)
    end
  end
end
