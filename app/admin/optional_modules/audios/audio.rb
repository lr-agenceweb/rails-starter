# frozen_string_literal: true
ActiveAdmin.register Audio do
  menu parent: I18n.t('admin_menu.assets')

  permit_params :id,
                :audio,
                :audio_autoplay,
                :online

  # decorate_with AudioDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_online, if: proc { can? :toggle_online, Audio } do |ids|
    Audio.find(ids).each { |item| item.toggle! :online }
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.flash'))
  end

  index do
    selectable_column
    attachment_column(t('activerecord.attributes.audio.audio'), :audio, truncate: false)
    column :audioable
    bool_column :audio_autoplay
    bool_column :online
    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        attachment_row(t('activerecord.attributes.audio.audio'), :audio, truncate: false)
        row :audioable
        bool_row :audio_autoplay
        bool_row :online
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.audio_details') do
          f.input :audio,
                  as: :file,
                  hint: raw(f.object.decorate.hint_for_file)
          f.input :audio_autoplay
          f.input :online
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include OptionalModules::Audioable

    def destroy
      resource.audio.clear
      resource.save
      super
    end

    def edit
      @page_title = t('audio.aa_edit', article: resource.audioable.title)
    end
  end
end
