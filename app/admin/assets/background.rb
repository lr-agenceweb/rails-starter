ActiveAdmin.register Background do
  menu parent: 'Assets'

  permit_params :id,
                :attachable_type,
                :image,

  config.clear_sidebar_sections!
  actions :all

  index do
    selectable_column
    column 'Background' do |resource|
      retina_image_tag(resource, :image, :small)
    end

    column :attachable_type

    actions
  end

  show do
    h3 resource.attachable_type
    attributes_table do
      row :attachable_type
      row :background do
        retina_image_tag(resource, :image, :medium)
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Background properties' do
      f.input :attachable_type,
              collection: Background.child_classes,
              include_blank: false,
              input_html: { class: 'chosen-select' }
      f.input :image,
              as: :file,
              label: I18n.t('form.label.background'),
              image_preview: true
    end

    f.actions
  end
end
