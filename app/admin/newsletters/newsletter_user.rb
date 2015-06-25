ActiveAdmin.register NewsletterUser do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id, :role, :lang

  config.clear_sidebar_sections!

  index do
    selectable_column
    column :id
    column :email
    column :lang
    column :role
    column :created_at

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Newsletter user' do
      f.input :email, input_html: { disabled: :disabled }
      f.input :lang,
              collection: %w(fr en),
              include_blank: false,
              hint: 'Attention, changer ce paramètre changera la langue de la newsletter reçue par cet utilisateur !'
      f.input :role,
              collection: %w(subscriber tester),
              include_blank: false
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :set_newsletter_user, only: [:edit]

    private

    def set_newsletter_user
      @newsletter_user = NewsletterUser.find(params[:id])
    end
  end
end
