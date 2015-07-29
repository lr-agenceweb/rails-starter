ActiveAdmin.register Background do
  menu parent: 'Assets'

  permit_params :id, :image

  decorate_with BackgroundDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :image_deco
    column :category_name
    actions
  end

  show do
    h3 resource.category_name
    attributes_table do
      row :image_deco
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs t('active_admin.details', model: active_admin_config.resource_label) do
      f.input :attachable_type,
              collection: Background.child_classes,
              include_blank: false,
              input_html: { class: 'chosen-select' }
      f.input :image,
              as: :file,
              label: I18n.t('form.label.background'),
              hint: retina_image_tag(f.object, :image, :medium)
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :set_background, only: [:destroy]

    def destroy
      @bg.image.clear
      @bg.save
      super
    end

    private

    def set_background
      @bg = Background.find(params[:id])
    end
  end
end
