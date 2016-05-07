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

  batch_action :toggle_online do |ids|
    Audio.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
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
        f.inputs t('active_admin.details', model: active_admin_config.resource_label) do
          f.input :audio,
                  as: :file,
                  hint: raw("Fichier actuel: <strong>#{f.object.audio_file_name.humanize if f.object.audio.exists?}</strong> <br />") + raw(I18n.t('form.hint.audio.audio_file'))
          f.input :audio_autoplay,
                  hint: raw(I18n.t('form.hint.audio.autoplay'))
          f.input :online,
                  label: I18n.t('form.label.online'),
                  hint: I18n.t('form.hint.online')
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
