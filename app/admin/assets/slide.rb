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

  batch_action :toggle_value do |ids|
    Slide.find(ids).each do |slide|
      toggle_value = slide.online? ? false : true
      slide.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :image_deco
    column :title_deco
    column :description_deco
    column :slider_page_name
    column :status
    actions
  end

  show title: :title_aa_show, decorate: true do
    attributes_table do
      row :image_deco
      row :title_deco
      row :description_deco
      row :status
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
