ActiveAdmin.register NewsletterUser, as: 'LetterUser' do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id, :role, :lang

  decorate_with NewsletterUserDecorator
  config.clear_sidebar_sections!

  scope :all, default: true
  scope :francais
  scope :english

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
        f.inputs t('activerecord.models.newsletter_user.one') do
          f.input :email, input_html: { disabled: :disabled }
        end
      end

      column do
        f.inputs t('additional') do
          f.input :lang,
                  collection: %w( fr en ),
                  include_blank: false,
                  hint: 'Attention, changer ce paramètre changera la langue de la newsletter reçue par cet utilisateur !'
          f.input :role,
                  collection: %w( subscriber tester ),
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
    def update
      super { admin_letter_users_path }
    end
  end
end
