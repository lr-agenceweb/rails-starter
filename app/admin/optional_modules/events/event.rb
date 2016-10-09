# frozen_string_literal: true
ActiveAdmin.register Event do
  menu parent: I18n.t('admin_menu.modules')

  permit_params do
    params = [:id,
              :all_day,
              :start_date,
              :end_date,
              :show_as_gallery,
              :online,
              link_attributes: [
                :id, :url, :_destroy
              ],
              translations_attributes: [
                :id, :locale, :title, :slug, :content
              ],
              pictures_attributes: [
                :id, :image, :online, :position, :_destroy
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
              ]]
    params.push video_platforms_attributes: [:id, :url, :online, :position, :_destroy] if @video_module.enabled?
    params.push :show_calendar if @calendar_module.enabled?
    params
  end

  decorate_with EventDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online, if: proc { can? :reset_cache, Event } do |ids|
    Event.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :toggle_show_calendar, if: proc { can?(:reset_cache, Event) && @calendar_module.enabled? } do |ids|
    Event.find(ids).each { |event| event.toggle! :show_calendar }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, Event } do |ids|
    Event.find(ids).each(&:touch)
    redirect_to :back, notice: t('active_admin.batch_actions.reset_cache')
  end

  index do
    selectable_column
    image_column :image, style: :small do |r|
      r.picture.image if r.picture?
    end
    column :title
    bool_column :all_day
    column :start_date
    column :end_date
    bool_column :show_calendar if calendar_module.enabled?
    bool_column :online

    translation_status
    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            image_row :image, style: :medium do |r|
              r.picture.image
            end if resource.picture?
            row :content
            bool_row :all_day
            row :start_date
            row :end_date
            row :duration
            row :full_address
            row :link_with_link
            bool_row :show_as_gallery
            bool_row :show_calendar if calendar_module.enabled?
            bool_row :online
          end
        end

        column do
          render 'admin/shared/referencement/show', referencement: resource.referencement
        end
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
        end

        render 'admin/shared/form_translation', f: f
        render 'admin/shared/referencement/form', f: f
      end

      column do
        f.inputs t('activerecord.models.event.one') do
          f.input :all_day,
                  hint: I18n.t('form.hint.event.all_day')

          f.input :start_date,
                  as: :date_time_picker,
                  hint: I18n.t('form.hint.event.start_date')

          f.input :end_date,
                  as: :date_time_picker,
                  hint: I18n.t('form.hint.event.end_date')
        end

        render 'admin/shared/links/one', f: f
        render 'admin/shared/locations/one', f: f, title: t('location.event.title'), full: false
      end
    end

    columns do
      column do
        render 'admin/shared/pictures/many', f: f
      end

      column do
        render 'admin/shared/video_platforms/many', f: f
      end if video_settings.video_platform?
    end

    columns do
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
    include ActiveAdmin::Cachable
    include OptionalModules::Videoable

    def scoped_collection
      super.includes :translations, :location, :picture
    end

    def create
      reset_end_date if lasts_all_day?
      check_all_day if empty_end_date?
      super
    end

    def update
      reset_end_date if lasts_all_day?
      check_all_day if empty_end_date?
      super
    end

    private

    def reset_end_date
      params[:event][:start_date] = params[:event][:start_date].to_datetime.change(hour: 0, min: 0, sec: 0)
      params[:event][:end_date] = nil
    end

    def check_all_day
      params[:event][:all_day] = true
    end

    def lasts_all_day?
      params[:event][:all_day] == true
    end

    def empty_end_date?
      params[:event][:end_date].blank?
    end
  end
end
