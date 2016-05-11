# frozen_string_literal: true
ActiveAdmin.register Home do
  menu parent: I18n.t('admin_menu.posts')

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

  decorate_with HomeDecorator
  config.clear_sidebar_sections!

  action_item :edit_heading_page do
    edit_heading_page_aa
  end

  batch_action :toggle_online, if: proc { can? :toggle_online, Home } do |ids|
    Post.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, Home } do |ids|
    Post.find(ids).each(&:touch)
    redirect_to :back, notice: t('active_admin.batch_actions.reset_cache')
  end

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    render 'admin/posts/index', object: self
  end

  show do
    arbre_cache(self, resource.cache_key) do
      render 'admin/posts/show', resource: resource
    end
  end

  form do |f|
    render 'admin/posts/form', f: f
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include OptionalModules::Videoable

    cache_sweeper :home_sweeper

    before_create do |post|
      post.type = post.object.class.name
      post.user_id = current_user.id
    end
  end
end
