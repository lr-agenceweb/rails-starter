ActiveAdmin.register Comment, as: 'PostComment' do
  permit_params :id,
                :username,
                :email,
                :comment,
                :user_id,
                :role

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  index do
    selectable_column
    column :avatar
    column :mail
    column :message
    column :link_and_image_source
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :avatar
      row :mail
      row :message
      row :link_and_image_source
      row :created_at
    end
  end
end
