# frozen_string_literal: true
ActiveAdmin.register Background do
  menu parent: I18n.t('admin_menu.assets')

  permit_params :id, :image, :attachable_id, :attachable_type

  decorate_with BackgroundDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    image_column :image, style: :small
    column :page_name
    actions
  end

  show title: :title_aa_show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :page_name
        image_row :image, style: :medium
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs t('formtastic.titles.background_details') do
      f.input :attachable_id,
              as: :select,
              collection: Page.handle_pages_for_background(f.object),
              include_blank: false

      f.input :attachable_type,
              as: :hidden,
              input_html: { value: 'Page' }

      f.input :image,
              as: :file,
              hint: retina_image_tag(f.object, :image, :medium)
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    def scoped_collection
      super.includes attachable: [menu: [:translations]]
    end

    def edit
      @page_title = resource.decorate.title_aa_edit
    end

    def destroy
      resource.image.clear
      resource.save
      super
    end
  end
end
