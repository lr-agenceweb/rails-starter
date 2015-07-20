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

  batch_action :toggle_value do |ids|
    GuestBook.find(ids).each do |guest_book|
      toggle_value = guest_book.validated? ? false : true
      guest_book.update_attribute(:validated, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :username
    column :content
    column :lang
    column :status
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :username
      row :content
      row :lang
      row :status
      row :created_at
    end
  end
end
