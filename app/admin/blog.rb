ActiveAdmin.register Blog do
  menu parent: I18n.t('admin_menu.modules')
  includes :translations

  permit_params :id,
                :type,
                :online,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                pictures_attributes: [
                  :id, :locale, :image, :_destroy
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with BlogDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :image
    column :title
    column :status
    translation_status
    column :author_with_avatar

    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :content
          row :status
          row :image
          row :author_with_avatar
        end
      end

      column do
        render 'admin/shared/referencement/show', referencement: resource.referencement
      end
    end
  end

  form do |f|
    render 'admin/posts/form', f: f
  end

  #
  # == Controller
  #
  controller do
    before_create do |blog|
      blog.user_id = current_user.id
    end
  end
end
