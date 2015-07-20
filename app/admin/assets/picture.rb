ActiveAdmin.register Picture do
  menu parent: 'Assets'

  permit_params :id,
                :online,
                :image,
                translations_attributes: [
                  :id, :locale, :title, :description
                ]

  decorate_with PictureDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_value do |ids|
    Picture.find(ids).each do |picture|
      toggle_value = picture.online? ? false : true
      picture.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :image
    column :source_picture_title_link
    column :status

    translation_status
    actions
  end

  show do
    attributes_table do
      row :image_large
      row :source_picture_title_link
      row :description
      row :status
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('active_admin.details', model: active_admin_config.resource_label) do
          f.input :image,
                  as: :file,
                  hint: retina_image_tag(f.object, :image, :medium)
          f.input :online,
                  label: I18n.t('form.label.online'),
                  hint: I18n.t('form.hint.online')
        end
      end

      column do
        f.inputs t('additional') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title
            t.input :description,
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
    before_action :set_picture, only: [:toggle_online]

    def toggle_online
      new_value = @picture.online? ? false : true
      @picture.update_attribute(:online, new_value)
      make_redirect
    end

    private

    def set_picture
      @picture = Picture.find(params[:id])
    end

    def make_redirect
      redirect_to :back
    end
  end
end
