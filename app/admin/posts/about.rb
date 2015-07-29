ActiveAdmin.register About do
  menu parent: 'Articles'
  includes :translations

  permit_params :id,
                :type,
                :online,
                :allow_comments,
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

  decorate_with AboutDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    Post.find(ids).each do |post|
      toggle_value = post.online? ? false : true
      post.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

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
    render 'admin/posts/show', resource: resource
  end

  form do |f|
    render 'admin/posts/form', f: f
  end

  #
  # == Controller
  #
  controller do
    before_create do |post|
      post.type = post.object.class.name
      post.user_id = current_user.id
    end

    def create
      delete_key_before_save
      super
    end

    def update
      delete_key_before_save
      super
    end

    private

    def delete_key_before_save
      params[:about].delete :allow_comments unless @comment_module.enabled?
    end
  end
end
