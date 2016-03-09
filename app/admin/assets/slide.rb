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

  batch_action :toggle_online do |ids|
    Slide.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    image_column :image, style: :crop_thumb
    column :title
    column :description_deco
    column :attachable
    column :status
    actions
  end

  show title: :title_aa_show, decorate: true do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        image_row :image, style: :small
        row :title
        row :description_deco
        row :status
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs 'Contenu de la slide' do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title,
                    label: I18n.t('activerecord.attributes.slide.title'),
                    hint: I18n.t('form.hint.slide.title')
            t.input :description,
                    label: I18n.t('activerecord.attributes.slide.description'),
                    hint: I18n.t('form.hint.slide.description'),
                    input_html: { class: '' }
          end
        end
      end

      column do
        f.inputs t('active_admin.details', model: active_admin_config.resource_label) do
          f.input :image,
                  as: :file,
                  label: I18n.t('form.label.slide'),
                  hint: "#{retina_image_tag(f.object, :image, :small)} <br/> #{I18n.t('form.hint.slide.size')}".html_safe
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

    cache_sweeper :slide_sweeper

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
