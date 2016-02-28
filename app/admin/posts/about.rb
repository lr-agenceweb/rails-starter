ActiveAdmin.register About do
  menu parent: I18n.t('admin_menu.posts')
  includes :translations

  permit_params do
    params = [:id,
              :type,
              :show_as_gallery,
              :online,
              :user_id,
              translations_attributes: [
                :id, :locale, :title, :slug, :content
              ],
              pictures_attributes: [
                :id, :locale, :image, :online, :position, :_destroy
              ],
              video_uploads_attributes: [
                :id, :online, :position,
                :video_file,
                :video_autoplay,
                :video_loop,
                :video_controls,
                :video_mute,
                :_destroy,
                video_subtitle_attributes: [
                  :id, :subtitle_fr, :subtitle_en, :online, :delete_subtitle_fr, :delete_subtitle_en
                ]
              ],
              referencement_attributes: [
                :id,
                translations_attributes: [
                  :id, :locale, :title, :description, :keywords
                ]
              ]
             ]

    params.push video_platforms_attributes: [:id, :url, :online, :position, :_destroy] if @video_module.enabled?
    params.push :allow_comments if @comment_module.enabled?
    params
  end

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

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    selectable_column
    image_column :image, style: :small do |r|
      r.picture.image if r.picture?
    end
    column :title
    column :allow_comments_status if comment_module.enabled?
    column :show_as_gallery
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
    include OptionalModules::Videoable

    before_create do |post|
      post.type = post.object.class.name
      post.user_id = current_user.id
    end
  end
end
