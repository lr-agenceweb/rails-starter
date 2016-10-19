# frozen_string_literal: true

#
# == ModuleSettingableConcern
#
module ModuleSettingable
  extend ActiveSupport::Concern

  included do
    before_action :set_model_value
    before_action :set_module_setting

    private

    def set_model_value
      ctrl = controller_name.classify
      @model_value = ctrl.gsub(/User|Message|Category/, '')
    end

    def set_module_setting
      klass = "#{@model_value}Setting".constantize
      instance_variable_set :"@#{@model_value.underscore}_setting", klass.first
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
