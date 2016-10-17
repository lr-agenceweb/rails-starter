# frozen_string_literal: true
ActiveAdmin.register Slide do
  menu parent: I18n.t('admin_menu.assets')
  includes :translations, :attachable

  permit_params :id,
                :image,
                :online,
                translations_attributes: [
                  :id, :locale, :title, :description
                ]

  decorate_with SlideDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online, if: proc { can? :toggle_online, Slide } do |ids|
    Slide.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    image_column :image, style: :crop_thumb
    column :title
    column :description_d
    column :attachable
    bool_column :online
    actions
  end

  show title: :title_aa_show, decorate: true do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        image_row :image, style: :small
        row :title
        row :description_d
        bool_row :online
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    render 'admin/slides/many', item: f

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include ActiveAdmin::Cachable

    def scoped_collection
      super.includes attachable: [category: [menu: [:translations]]]
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
