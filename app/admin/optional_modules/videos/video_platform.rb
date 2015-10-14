ActiveAdmin.register VideoPlatform do
  menu parent: I18n.t('admin_menu.assets')
  includes :videoable

  permit_params :id,
                :url,
                :native_informations,
                :online,
                translations_attributes: [
                  :id, :locale, :title, :description
                ]

  decorate_with VideoPlatformDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    VideoPlatform.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :preview
    column :video_link
    column :from_article
    column :status

    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :preview
          row :video_link
          row :from_article
          row :status
        end
      end

      column do
        attributes_table do
          row :native_informations_d
          row :title_d
          row :description_d
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :url,
                  hint: raw("#{t('form.hint.video.url')} <br /><br /> #{f.object.decorate.preview}")

          f.input :online,
                  as: :boolean,
                  hint: t('form.hint.video.online')
        end
      end

      column do
        f.inputs 'Contenu de la vidéo' do
          f.input :native_informations,
                  as: :boolean,
                  hint: t('form.hint.video.native_informations')

          f.translated_inputs 'Translated fields', switch_locale: true, class: 'aazazaz' do |t|
            t.input :title,
                    label: I18n.t('activerecord.attributes.video_upload.title')
            t.input :description,
                    label: I18n.t('activerecord.attributes.video_upload.description'),
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
    def edit
      @page_title = "#{t('active_admin.edit')} #{I18n.t('activerecord.models.video_platform.one')} article \"#{resource.decorate.from_article.title}\""
    end
  end
end
