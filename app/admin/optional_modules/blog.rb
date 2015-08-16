ActiveAdmin.register Blog do
  menu parent: I18n.t('admin_menu.modules')
  includes :translations

  permit_params :id,
                :type,
                :allow_comments,
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

  decorate_with BlogDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    Blog.find(ids).each do |blog|
      toggle_value = blog.online? ? false : true
      blog.update_attribute(:online, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :image
    column :title
    column :allow_comments_status
    column :status
    translation_status
    column :author_with_avatar

    actions
  end

  show title: :title_aa_show do
    render 'admin/posts/show', resource: resource
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
      params[:blog].delete :allow_comments unless @comment_module.enabled?
    end
  end
end
