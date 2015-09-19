ActiveAdmin.register About do
  menu parent: I18n.t('admin_menu.posts')
  includes :translations

  permit_params :id,
                :type,
                :show_as_gallery,
                :online,
                :allow_comments,
                :user_id,
                translations_attributes: [
                  :id, :locale, :title, :slug, :content
                ],
                pictures_attributes: [
                  :id, :locale, :image, :online, :position, :_destroy
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ]

  decorate_with AboutDecorator
  config.clear_sidebar_sections!

  action_item :edit_heading_page do
    edit_heading_page_aa
  end

  action_item :new_article, only: [:show] do
    link_to I18n.t('active_admin.action_item.new_article'), new_admin_about_path if can? :create, About
  end

  action_item :show_article, only: [:show] do
    link_to I18n.t('active_admin.action_item.see_article_in_frontend'), about_path(resource), target: :blank
  end

  batch_action :toggle_online do |ids|
    About.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :image
    column :title
    column :allow_comments_status
    column :show_as_gallery_d
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
