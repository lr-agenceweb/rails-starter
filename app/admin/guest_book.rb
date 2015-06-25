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

  decorate_with GuestBookDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :username
    column :lang
    column :content
    column :validated
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :username
      row :lang
      row :content
      row :validated
      row :created_at
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
