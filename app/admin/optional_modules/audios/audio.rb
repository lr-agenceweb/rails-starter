# frozen_string_literal: true
ActiveAdmin.register Audio do
  menu parent: I18n.t('admin_menu.assets')

  permit_params :id,
                :online,
                :audio

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
    bool_column :online
    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        attachment_row(t('activerecord.attributes.audio.audio'), :audio, truncate: false)
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
                  hint: I18n.t('form.hint.audio.audio_file')
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
  end
end
