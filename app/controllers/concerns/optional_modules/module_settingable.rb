#
# == ModuleSettingableConcern
#
module ModuleSettingable
  extend ActiveSupport::Concern

  included do
    before_action :set_module_setting

    def set_module_setting
      model_name = controller_name.classify
      klass = "#{model_name}Setting".constantize
      instance_variable_set :"@#{model_name.underscore}_setting", klass.first
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
