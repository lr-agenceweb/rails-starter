# frozen_string_literal: true

#
# ModuleSettingableConcern
# ===========================
module ModuleSettingable
  extend ActiveSupport::Concern

  included do
    before_action :set_model_value
    before_action :set_module_setting
    before_action :set_mailing_setting,
                  if: proc {
                    %w(Newsletter Contact).include?(@model_value)
                  }

    private

    def set_model_value
      ctrl = controller_name.classify
      @model_value = ctrl.gsub(/User|Message|Category/, '')
    end

    def set_module_setting
      return unless Object.const_defined?("#{@model_value}Setting")
      klass = "#{@model_value}Setting".constantize
      instance_variable_set :"@#{@model_value.underscore}_setting", klass.first
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end

    def set_mailing_setting
      @mailing_setting = MailingSetting.first.decorate
    end
  end
end
