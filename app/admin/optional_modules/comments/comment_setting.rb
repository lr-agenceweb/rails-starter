ActiveAdmin.register CommentSetting do
  menu parent: I18n.t('admin_menu.modules_config')
  includes :user

  permit_params :id, :should_signal, :send_email

  decorate_with CommentSettingDecorator
  config.clear_sidebar_sections!

  show do
    attributes_table do
      row :should_signal
      row :send_email if resource.should_signal?
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs I18n.t('activerecord.models.comment_setting.one') do
      f.input :should_signal,
              as: :boolean,
              hint: I18n.t('form.hint.comment_setting.should_signal')
      f.input :send_email,
              as: :boolean,
              hint: I18n.t('form.hint.comment_setting.send_email')
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
