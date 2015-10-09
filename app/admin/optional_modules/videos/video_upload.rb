ActiveAdmin.register VideoUpload do
  menu parent: I18n.t('admin_menu.assets')

  permit_params :id,
                :video_file,
                :online,
                video_subtitle_attributes: [
                  :id, :online, :subtitle_fr, :subtitle_en, :_destroy
                ]

  decorate_with VideoUploadDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    VideoUpload.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :preview
    column :from_article
    column :status

    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :preview
          row :from_article
          row :status
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :video_file,
                  as: :file,
                  label: I18n.t('form.label.video'),
                  hint: raw(f.object.decorate.preview) unless f.object.new_record?
          f.input :online,
                  hint: I18n.t('form.hint.video.online')
        end
      end

      column do
        render 'admin/subtitles/form', f: f
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
  end
end
