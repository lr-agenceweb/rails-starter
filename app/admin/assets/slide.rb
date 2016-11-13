# frozen_string_literal: true
ActiveAdmin.register Slide do
  menu parent: I18n.t('admin_menu.assets')
  includes :translations, :attachable

  permit_params :id, :image, :online,
                translations_attributes: [
                  :id, :locale, :title, :description
                ]

  decorate_with SlideDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online, if: proc { can? :toggle_online, Slide } do |ids|
    Slide.find(ids).each { |item| item.toggle! :online }
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.flash'))
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

    columns do
      column do
        f.inputs t('formtastic.titles.slide_picture') do
          hint = "#{t('formtastic.hints.slide.size')} <br /><br /> #{retina_image_tag(f.object, :image, :small)}".html_safe
          f.input :image,
                  as: :file,
                  hint: hint

          f.input :online
        end
      end

      column do
        f.inputs t('formtastic.titles.slide_content') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title
            t.input :description,
                    input_html: { class: 'small-height' }
          end
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
    include ActiveAdmin::Cachable

    def scoped_collection
      super.includes attachable: [page: [menu: [:translations]]]
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
