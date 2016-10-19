# frozen_string_literal: true
ActiveAdmin.register Event do
  menu parent: I18n.t('admin_menu.modules')

  permit_params do
    params = [:all_day, :start_date, :end_date]

    params.push(*general_attributes)
    params.push(*post_attributes)
    params.push(*referencement_attributes)
    params.push(*link_attributes)
    params.push(*location_attributes)
    params.push(*picture_attributes(true))
    params.push(*video_upload_attributes(true)) if @video_module.enabled?
    params.push(*video_platform_attributes(true)) if @video_module.enabled?
    params.push :show_calendar if @calendar_module.enabled?
    params.push :show_map if @map_module.enabled? && @event_setting.show_map?
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
    bool_column :show_map if map_module.enabled? && event_setting.show_map?
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
            bool_row :show_map if map_module.enabled? && event.show_map?
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
        f.inputs t('formtastic.titles.post_generals') do
          f.input :online
          f.input :show_as_gallery
          f.input :show_calendar if calendar_module.enabled?
          f.input :show_map if map_module.enabled? && event_setting.show_map?
        end

        render 'admin/shared/form_translation', f: f
      end

      column do
        f.inputs t('formtastic.titles.event_date_details') do
          f.input :all_day
          f.input :start_date, as: :date_time_picker
          f.input :end_date, as: :date_time_picker
        end

        render 'admin/shared/links/one', f: f
        render 'admin/shared/locations/one', f: f, full: true
        render 'admin/shared/referencement/form', f: f
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
    include ActiveAdmin::ParamsHelper
    include Skippable
    include ModuleSettingable
    include ActiveAdmin::Cachable
    include ActiveAdmin::AjaxDestroyable
    include OptionalModules::Videoable

    def scoped_collection
      super.includes :translations, :location, :picture
    end
  end
end
