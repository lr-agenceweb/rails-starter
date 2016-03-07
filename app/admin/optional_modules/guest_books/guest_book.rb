ActiveAdmin.register GuestBook do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :username,
                :content,
                :lang,
                :validated

  scope I18n.t('scope.all'), :all, default: true
  scope I18n.t('scope.validated'), :validated
  scope I18n.t('scope.to_validate'), :to_validate
  scope I18n.t('active_admin.globalize.language.fr'), :french
  scope I18n.t('active_admin.globalize.language.en'), :english

  decorate_with GuestBookDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_validated do |ids|
    GuestBook.find(ids).each { |item| item.toggle! :validated }
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
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :username
        row :content
        row :lang
        row :status
        row :created_at
      end
    end
  end

  #
  # == Controller
  #
  controller do
    include Skippable
  end
end
