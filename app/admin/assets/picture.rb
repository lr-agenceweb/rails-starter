ActiveAdmin.register Picture do
  menu parent: 'Assets'

  permit_params :id,
                :online,
                :image,
                translations_attributes: [
                  :id, :locale, :title, :description
                ]

  config.clear_sidebar_sections!
  actions :all, except: [:new]

  index do
    column 'Picture' do |resource|
      retina_image_tag(resource, :image, :medium)
    end

    column 'Type' do |resource|
      resource.attachable_type
    end

    column :online do |resource|
      span status_tag("#{resource.online}", (resource.online? ? :ok : :warn))
    end

    translation_status
    actions
  end

  index as: :grid do |resource|
    raw "#{retina_image_tag(resource, :image, :medium)}<br><strong>#{resource.title}</strong>"
  end

  show do
    h3 resource.title
    attributes_table do
      row :description do
        raw resource.description
      end
      row :resource do
        retina_image_tag(resource, :image, :medium)
      end

      row :online do
        status_tag("#{resource.online}", (resource.online? ? :ok : :warn))
      end
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
