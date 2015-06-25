ActiveAdmin.register Home do
  menu parent: 'Articles'

  permit_params :id,
                :type,
                :online,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with HomeDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :image
    column :title
    column :online

    translation_status
    actions
  end

  show do
    h3 resource.title
    attributes_table do
      row :content
      row :online
      row :image

      render 'admin/shared/referencement/show', resource: resource
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    render 'admin/shared/form_general', f: f
    render 'admin/shared/form_translation', f: f
    render 'admin/shared/referencement/form', f: f
    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :set_home, only: [:show, :edit, :update, :destroy, :toggle_home_online]
    before_create do |post|
      post.type = 'Home'
      post.user_id = current_user.id
    end

    def toggle_home_online
      new_value = @home.online? ? false : true
      @home.update_attribute(:online, new_value)
      make_redirect
    end

    private

    def set_home
      @home = Home.friendly.find(params[:id])
    end

    def make_redirect
      redirect_to :back
    end
  end
end
