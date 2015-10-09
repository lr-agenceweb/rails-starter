ActiveAdmin.register VideoUpload do
  menu parent: I18n.t('admin_menu.assets')

  permit_params :id,
                :video,
                :online

  decorate_with VideoUploadDecorator
  config.clear_sidebar_sections!

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
          f.input :video,
                  as: :file,
                  label: I18n.t('form.label.video'),
                  hint: raw("#{retina_image_tag(f.object, :video, :preview) unless f.object.new_record?}")
          f.input :online,
                  hint: I18n.t('form.hint.video.online')
        end
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
