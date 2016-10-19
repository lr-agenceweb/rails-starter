# frozen_string_literal: true
ActiveAdmin.register Blog do
  menu parent: I18n.t('admin_menu.modules')
  includes :translations, :video_upload, :publication_date, blog_category: [:translations]

  permit_params do
    params = [:type, :user_id, :blog_category_id]

    params.push(*general_attributes)
    params.push(*post_attributes)
    params.push(*referencement_attributes)
    params.push(*publication_date_attributes)
    params.push(*picture_attributes(true))
    params.push(*video_upload_attributes) if @video_module.enabled?
    params.push(*video_platform_attributes) if @video_module.enabled?
    params.push(*audio_attributes) if @audio_module.enabled?
    params.push :allow_comments if @comment_module.enabled?
    params
  end

  decorate_with BlogDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_online, if: proc { can? :toggle_online, Blog } do |ids|
    Blog.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, Blog } do |ids|
    Blog.find(ids).each(&:touch)
    redirect_to :back, notice: t('active_admin.batch_actions.reset_cache')
  end

  index do
    render 'admin/posts/index', object: self, show_blog_category: true, custom_cover: true
  end

  show title: :title_aa_show do
    arbre_cache(self, resource.cache_key) do
      render 'admin/posts/show', resource: resource, custom_cover: true
    end
  end

  form do |f|
    render 'admin/posts/form', f: f, has_one_relation: true
  end

  #
  # == Controller
  #
  controller do
    include ActiveAdmin::ParamsHelper
    include Skippable
    include ActiveAdmin::Cachable
    include ActiveAdmin::AjaxDestroyable
    include OptionalModules::Videoable
    include OptionalModules::Audioable

    before_create do |blog|
      blog.user_id = current_user.id
    end

    def scoped_collection
      super.includes :picture, :user
    end
  end
end
