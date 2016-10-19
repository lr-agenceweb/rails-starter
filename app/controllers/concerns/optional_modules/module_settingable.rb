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
      case controller_name.classify
      when 'NewsletterUser'
        @model_value = 'Newsletter'
      when 'MailingUser', 'MailingMessage'
        @model_value = 'Mailing'
      when 'BlogCategory'
        @model_value = 'Blog'
      else
        @model_value = controller_name.classify
      end
    end

    def set_module_setting
      klass = "#{@model_value}Setting".constantize
      instance_variable_set :"@#{@model_value.underscore}_setting", klass.first
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
