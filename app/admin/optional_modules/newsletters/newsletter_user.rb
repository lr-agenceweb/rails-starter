ActiveAdmin.register NewsletterUser do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :lang,
                :newsletter_user_role_id

  decorate_with NewsletterUserDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:show]

  action_item :update_newsletter_setting, only: [:index, :show] do
    link_to I18n.t('active_admin.action_item.update_newsletter_setting'), edit_admin_newsletter_setting_path(NewsletterSetting.first)
  end

  scope I18n.t('scope.all'), :all, default: true
  scope I18n.t('active_admin.globalize.language.fr'), :french
  scope I18n.t('active_admin.globalize.language.en'), :english

  sidebar I18n.t('newsletter.active_admin.subscriber_by_lang'), only: :index do
    pie_chart NewsletterUser.subscribers.group(:lang).count, height: '150px'
  end

  index do
    selectable_column
    column :email
    column :lang
    column :role_status
    column :created_at

    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('activerecord.models.letter_user.one') do
          f.input :email, input_html: { disabled: :disabled }
        end
      end

      column do
        f.inputs t('additional') do
          f.input :lang,
                  collection: I18n.available_locales.map { |i| [i.to_s] },
                  include_blank: false,
                  hint: 'Attention, changer ce paramètre changera la langue de la newsletter reçue par cet utilisateur !'

          f.input :newsletter_user_role_id,
                  as: :select,
                  collection: NewsletterUserRole.newsletter_user_role_dropdown,
                  include_blank: false
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
      super.includes newsletter_user_role: [:translations]
    end

    def update
      super { admin_newsletter_users_path }
    end
  end
end
