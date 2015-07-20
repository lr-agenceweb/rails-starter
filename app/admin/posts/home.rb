ActiveAdmin.register Home do
  menu parent: 'Articles'

  permit_params :id,
                :type,
                :online,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                pictures_attributes: [
                  :id, :locale, :image, :online, :_destroy
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with HomeDecorator
  config.clear_sidebar_sections!

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    selectable_column
    column :image
    column :title
    column :online
    translation_status
    column :author_with_avatar

    actions
  end

  show do
    render 'admin/posts/show', resource: resource
  end

  form do |f|
    render 'admin/posts/form', f: f
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
