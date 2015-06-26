ActiveAdmin.register About do
  menu parent: 'Articles'
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

  decorate_with AboutDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :image
    column :title
    column :status

    translation_status
    actions
  end

  show do
    attributes_table do
      row :content
      row :status
      row :image

      render 'admin/shared/referencement/show', resource: resource
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    render 'admin/shared/form_general', f: f
    render 'admin/shared/form_translation', f: f
    render 'admin/shared/pictures/many', f: f
    render 'admin/shared/referencement/form', f: f
    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_create do |post|
      post.type = 'About'
      post.user_id = current_user.id
    end
  end
end
