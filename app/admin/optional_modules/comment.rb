ActiveAdmin.register Comment, as: 'PostComment' do
  menu parent: I18n.t('admin_menu.modules')
  includes :user

  permit_params :id,
                :username,
                :email,
                :comment,
                :user_id,
                :role

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  scope :all, default: true
  scope :francais
  scope :english

  index do
    selectable_column
    column :avatar
    column :mail
    column :message
    column :lang
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
      row :link_and_image_source
      row :created_at
    end
  end
end
