# frozen_string_literal: true
ActiveAdmin.register Blog do
  menu parent: I18n.t('admin_menu.modules')
  includes :translations, blog_category: [:translations]

  permit_params do
    params = [:id,
              :type,
              :show_as_gallery,
              :online,
              :user_id,
              :blog_category_id,
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
    params.push audio_attributes: [:id, :audio, :online, :_destroy] if @audio_module.enabled?
    params.push :allow_comments if @comment_module.enabled?
    params
  end

  decorate_with BlogDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online do |ids|
    Blog.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :reset_cache do |ids|
    Blog.find(ids).each(&:touch)
    redirect_to :back, notice: t('active_admin.batch_actions.reset_cache')
  end

  index do
    render 'admin/posts/index', object: self, show_blog_category: true
  end

  show title: :title_aa_show do
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
    include OptionalModules::Audioable

    cache_sweeper :blog_sweeper

    before_create do |blog|
      blog.user_id = current_user.id
    end

    def scoped_collection
      super.includes :picture, :user
    end
  end
end
