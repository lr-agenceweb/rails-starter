ActiveAdmin.register VideoSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params do
    params = [:id,
              :video_platform,
              :video_upload,
              :turn_off_the_light
             ]
    params.push :video_background if current_user.super_administrator?
    params
  end

  decorate_with VideoSettingDecorator
  config.clear_sidebar_sections!

  show title: I18n.t('activerecord.models.video_setting.one') do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            bool_row :video_platform
            bool_row :video_upload
            bool_row :video_background if resource.video_background?
            bool_row :turn_off_the_light
          end
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

          f.input :turn_off_the_light,
                  hint: I18n.t('form.hint.video.turn_off_the_light')
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

    private

    def redirect_to_dashboard
      redirect_to admin_dashboard_path
    end

    def redirect_to_show
      redirect_to admin_video_setting_path(VideoSetting.first), status: 301
    end
  end
end
