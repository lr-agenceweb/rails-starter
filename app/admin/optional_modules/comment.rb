ActiveAdmin.register Comment, as: 'PostComment' do
  menu parent: I18n.t('admin_menu.modules')
  includes :user

  permit_params :id,
                :username,
                :email,
                :comment,
                :user_id,
                :role,
                :validated,
                :signalled

  scope I18n.t('scope.all'), :all, default: true
  scope I18n.t('active_admin.globalize.language.fr'), :french
  scope I18n.t('active_admin.globalize.language.en'), :english
  scope I18n.t('comment.signalled'), :signalled

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_validated do |ids|
    Comment.find(ids).each { |item| item.toggle! :validated }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :toggle_signalled do |ids|
    Comment.find(ids).each { |item| item.toggle! :signalled }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :author_with_avatar
    column :mail
    # column :message
    column :lang
    column :status
    column :signalled_d
    column :link_and_image_source
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :author_with_avatar
      row :mail
      row :message
      row :lang
      row :status
      row :signalled_d
      row :link_and_image_source
      row :created_at
    end
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    def scoped_collection
      super.includes user: [:role]
    end
  end
end
