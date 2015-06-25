ActiveAdmin.register Background do
  menu parent: 'Assets'

  permit_params :id,
                :image

  decorate_with BackgroundDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :image
    column :category_name
    actions
  end

  show do
    h3 resource.category_name
    attributes_table do
      row :image
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
              label: I18n.t('form.label.background')
              # image_preview: true
    end

    f.actions
  end
end
