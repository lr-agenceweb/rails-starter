ActiveAdmin.register Comment, as: 'PostComment' do
  menu parent: I18n.t('admin_menu.modules')
  includes :user

  permit_params :id,
                :username,
                :email,
                :comment,
                :user_id,
                :role,
                :validated

  scope :all, default: true
  scope :francais
  scope :english

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_validated do |ids|
    Comment.find(ids).each { |item| item.toggle! :validated }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :avatar
    column :mail
    column :message
    column :lang
    column :status
    column :link_and_image_source
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :avatar
      row :mail
      row :message
      row :lang
      row :status
      row :link_and_image_source
      row :created_at
    end
  end

  #
  # == Controller
  #
  controller do
    include Skippable
  end
end
