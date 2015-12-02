ActiveAdmin.register VideoSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :video_platform,
                :video_upload,
                :video_background

  decorate_with VideoSettingDecorator
  config.clear_sidebar_sections!

  show do
    columns do
      column do
        attributes_table do
          row :video_platform_d
          row :video_upload_d
          row :video_background_d if resource.video_background?
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :video_platform,
                  hint: I18n.t('form.hint.video.video_platform')
          f.input :video_upload,
                  hint: I18n.t('form.hint.video.video_upload')

          if current_user.super_administrator?
            f.input :video_background,
                    hint: I18n.t('form.hint.video.video_background')
          end
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :redirect_to_dashboard, if: proc { current_user.subscriber? || !@video_module.enabled? }
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @video_module.enabled? }

    def index
      @collection ||= VideoSetting.all.page(1).per(1)
    end

    def update
      remove_video_background_param
      super
    end

    private

    def redirect_to_dashboard
      redirect_to admin_dashboard_path
    end

    def redirect_to_show
      redirect_to admin_video_setting_path(VideoSetting.first), status: 301
    end

    def remove_video_background_param
      params[:video_setting].delete :video_background unless current_user.super_administrator?
    end
  end
end
