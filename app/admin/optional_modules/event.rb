ActiveAdmin.register Event do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :url,
                :start_date,
                :end_date,
                :show_as_gallery,
                :show_calendar,
                :online,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                pictures_attributes: [
                  :id, :image, :online, :position, :_destroy
                ],
                video_platforms_attributes: [
                  :id, :url, :online, :position, :_destroy
                ],
                video_uploads_attributes: [
                  :id, :online, :position,
                  :video_file,
                  :video_autoplay,
                  :video_loop,
                  :video_controls,
                  :video_mute,
                  :_destroy,
                  video_subtitle_attributes: [
                    :id, :subtitle_fr, :subtitle_en, :online, :delete_subtitle_fr, :delete_subtitle_en
                  ]
                ],
                location_attributes: [
                  :id, :address, :city, :postcode
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with EventDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    Event.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :toggle_show_calendar, if: proc { @calendar_module.enabled? } do |ids|
    Event.find(ids).each { |event| event.toggle! :show_calendar }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :image
    column :title
    column :start_date
    column :end_date
    column :duration
    column :url
    column :show_calendar_d if calendar_module.enabled?
    column :status
    column :full_address_inline

    translation_status
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :image
          row :content
          row :start_date
          row :end_date
          row :duration
          row :url
          row :show_as_gallery_d
          row :show_calendar_d if calendar_module.enabled?
          row :status
          row :full_address_inline
        end
      end

      column do
        render 'admin/shared/referencement/show', referencement: resource.referencement
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :show_as_gallery,
                  hint: I18n.t('form.hint.picture.show_as_gallery')

          if calendar_module.enabled?
            f.input :show_calendar,
                    hint: I18n.t('form.hint.event.show_calendar')
          end

          f.input :online, hint: I18n.t('form.hint.event.online')
          f.input :url, hint: I18n.t('form.hint.event.link')
        end
      end

      column do
        render 'admin/shared/locations/one', f: f, title: t('location.event.title'), full: false
      end
    end

    columns do
      column do
        render 'admin/shared/form_translation', f: f
      end

      column do
        f.inputs t('activerecord.models.event.one') do
          f.input :start_date,
                  as: :string,
                  input_html: {
                    class: 'datetimepicker',
                    value: f.object.start_date.blank? ? '' : f.object.start_date.localtime.to_s(:db)
                  },
                  hint: I18n.t('form.hint.event.start_date')

          f.input :end_date,
                  as: :string,
                  input_html: {
                    class: 'datetimepicker',
                    value: f.object.end_date.blank? ? '' : f.object.end_date.localtime.to_s(:db)
                  },
                  hint: I18n.t('form.hint.event.end_date')
        end
      end
    end # columns

    columns do
      column do
        render 'admin/shared/pictures/many', f: f
      end

      column do
        render 'admin/shared/referencement/form', f: f
      end
    end

    columns do
      column do
        render 'admin/shared/video_platforms/many', f: f
      end if video_settings.video_platform?

      column do
        render 'admin/shared/video_uploads/many', f: f
      end if video_settings.video_upload?
    end if video_module.enabled?

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include Videoable

    def create
      remove_calendar_param
      super
    end

    def update
      remove_calendar_param
      super
    end

    private

    def remove_calendar_param
      params[:event].delete :show_calendar unless @calendar_module.enabled?
    end
  end
end
