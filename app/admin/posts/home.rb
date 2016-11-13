# frozen_string_literal: true
ActiveAdmin.register Home do
  menu parent: I18n.t('admin_menu.posts')

  permit_params do
    params = [:type, :user_id]

    params.push(*general_attributes)
    params.push(*post_attributes)
    params.push(*referencement_attributes)
    params.push(*picture_attributes(true))
    params.push(*video_upload_attributes(true)) if @video_module.enabled?
    params.push(*video_platform_attributes(true)) if @video_module.enabled?
    params.push :allow_comments if @comment_module.enabled?
    params
  end

  decorate_with HomeDecorator
  config.clear_sidebar_sections!

  action_item :edit_heading do
    action_item_page
  end

  action_item :edit_referencement do
    action_item_page(nil, 'referencement')
  end

  batch_action :toggle_online, if: proc { can? :toggle_online, Home } do |ids|
    Post.find(ids).each { |item| item.toggle! :online }
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.flash'))
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, Home } do |ids|
    Post.find(ids).each(&:touch)
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.reset_cache'))
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
    include ActiveAdmin::ParamsHelper
    include Skippable
    include ActiveAdmin::Postable
    include ActiveAdmin::Cachable
    include OptionalModules::Videoable
  end
end
