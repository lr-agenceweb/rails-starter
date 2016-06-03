# frozen_string_literal: true
ActiveAdmin.register CommentSetting do
  menu parent: I18n.t('admin_menu.modules_config')
  includes :user

  permit_params :id,
                :should_signal,
                :send_email,
                :should_validate,
                :allow_reply

  decorate_with CommentSettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  show title: I18n.t('activerecord.models.comment_setting.one') do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        bool_row :should_validate
        bool_row :should_signal
        bool_row :send_email if resource.should_signal?
        bool_row :allow_reply
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs I18n.t('activerecord.models.comment_setting.one') do
      f.input :should_validate,
              as: :boolean,
              hint: I18n.t('form.hint.comment_setting.should_validate')
      f.input :should_signal,
              as: :boolean,
              hint: I18n.t('form.hint.comment_setting.should_signal')
      f.input :send_email,
              as: :boolean,
              hint: I18n.t('form.hint.comment_setting.send_email')
      f.input :allow_reply,
              as: :boolean,
              hint: I18n.t('form.hint.comment_setting.allow_reply')
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @comment_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_comment_setting_path(CommentSetting.first), status: 301
    end
  end
end
