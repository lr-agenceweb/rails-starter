ActiveAdmin.register GuestBook do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :username,
                :content,
                :lang,
                :validated

  scope :all, default: true
  scope :validated
  scope :to_validate
  scope :francais
  scope :english

  config.clear_sidebar_sections!

  index do
    selectable_column
    column :username
    column :lang

    column :content do |resource|
      raw resource.content
    end

    column :validated do |resource|
      status_tag("#{resource.validated}", (resource.validated? ? :ok : :warn))
      span link_to 'Toggle', toggle_guest_book_validated_path(resource), data: { confirm: 'Voulez vous changer le statut de ce message ?' }
    end

    column 'Ajouté le' do |resource|
      I18n.l(resource.created_at, format: :long)
    end

    actions
  end

  show do
    attributes_table do
      row :username
      row :lang

      row :content do
        raw resource.content
      end

      row :validated do
        status_tag("#{resource.validated}", (resource.validated? ? :ok : :warn))
        span link_to 'Toggle', toggle_guest_book_validated_path(resource), data: { confirm: 'Voulez vous changer le statut de ce message ?' }
      end
      row 'Ajouté le' do
        I18n.l(resource.created_at, format: :long)
      end
    end
  end

  #
  # == Controller
  #
  controller do
    before_action :set_guest_book, only: [:toggle_guest_book_validated]

    def toggle_guest_book_validated
      new_value = @guest_book.validated? ? false : true
      @guest_book.update_attribute(:validated, new_value)
      message = new_value == true ? 'Le message vient d\'être validé: il apparaîtra maintenant sur le site' : 'Le message n\'apparaitra plus sur le site'
      flash[:notice] = message
      make_redirect
    end

    private

    def set_guest_book
      @guest_book = GuestBook.find(params[:id])
    end

    def make_redirect
      redirect_to :back
    end
  end
end
