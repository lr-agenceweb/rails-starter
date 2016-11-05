# frozen_string_literal: true
ActiveAdmin.register Picture do
  menu parent: I18n.t('admin_menu.assets')

  permit_params :id,
                :online,
                :image,
                translations_attributes: [
                  :id, :locale, :title, :description
                ]

  decorate_with PictureDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_online, if: proc { can? :toggle_online, Picture } do |ids|
    Picture.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    image_column :image, style: :medium
    column :source_picture_title_link
    bool_column :online

    translation_status
    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        image_row :image, style: :large
        row :source_picture_title_link
        row :description
        bool_row :online
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.picture_details') do
          f.input :image,
                  as: :file,
                  hint: "#{t('formtastic.hints.image')} <br /><br />#{retina_image_tag(f.object, :image, :medium)}"
          f.input :online
        end
      end

      column do
        f.inputs t('formtastic.titles.picture_content_details') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title,
                    hint: t('formtastic.hints.picture.title')
            t.input :description,
                    hint: t('formtastic.hints.picture.description'),
                    input_html: { class: 'froala' }
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

    def scoped_collection
      super.includes attachable: [pictures: [:translations]]
    end

    def destroy
      resource.image.clear
      resource.save
      super
    end
  end
end
