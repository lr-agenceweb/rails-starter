# frozen_string_literal: true
#
# == DeletableCommentableConcern
#
module DeletableCommentable
  extend ActiveSupport::Concern

  included do
    before_action :reset_flash_alert, only: [:destroy]
    before_action :set_object_variable, only: [:destroy]

    # DELETE /comments/1 || livre-d-or/1
    # DELETE /comments/1.json || livre-d-or/1.json
    def destroy
      if can? :destroy, @object_variable
        if @object_variable.destroy
          flash.now[:success] = I18n.t('comment.destroy.success')
          respond_action 'destroy'
        else
          flash.now[:error] = I18n.t('comment.destroy.error')
          respond_action 'comments/forbidden'
        end
      else
        flash.now[:error] = I18n.t('comment.destroy.not_allowed')
        respond_action 'comments/forbidden'
      end
    end

    private

    def set_object_variable
      model_value = controller_name.classify
      @object_variable = instance_variable_get(:"@#{model_value.underscore}")
    end

    def reset_flash_alert
      flash.now[:success] = nil
      flash.now[:error] = nil
    end
  end
end
