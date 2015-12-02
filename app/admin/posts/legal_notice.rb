ActiveAdmin.register LegalNotice do
  menu parent: I18n.t('admin_menu.config')
  includes :translations

  permit_params :id,
                :type,
                :online,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  decorate_with LegalNoticeDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    About.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :title
    column :content
    column :status
    translation_status

    actions
  end

  show title: :title_aa_show do
    columns do
      column do
        panel t('active_admin.details', model: active_admin_config.resource_label) do
          attributes_table_for resource do
            row :content
            row :status
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Général' do
      f.input :online,
              label: I18n.t('form.label.online'),
              hint: I18n.t('form.hint.online')
    end

    f.inputs 'Contenu de l\'article' do
      f.translated_inputs 'Translated fields', switch_locale: true do |t|
        t.input :title,
                label: I18n.t('activerecord.attributes.post.title'),
                hint: I18n.t('form.hint.title')
        t.input :content,
                label: I18n.t('activerecord.attributes.post.content'),
                hint: I18n.t('form.hint.content'),
                input_html: { class: 'froala' }
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_create do |post|
      post.type = post.object.class.name
      post.user_id = current_user.id
    end
  end
end
