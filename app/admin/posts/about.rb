# frozen_string_literal: true
ActiveAdmin.register About do
  menu parent: I18n.t('admin_menu.posts')
  includes :translations

  permit_params do
    params = [:type, :user_id]
    params.push(*general_attributes)
    params.push(*post_attributes)
    params.push(*referencement_attributes)
    params.push(*picture_attributes(true))
    params
  end

  decorate_with AboutDecorator
  config.clear_sidebar_sections!

  action_item :edit_heading do
    action_item_page
  end

  action_item :edit_referencement do
    action_item_page(nil, 'referencement')
  end

  action_item :new_article, only: [:show] do
    link_to I18n.t('active_admin.action_item.new_article'), new_admin_about_path if can? :create, About
  end

  action_item :show_article, only: [:show] do
    link_to I18n.t('active_admin.action_item.see_article_in_frontend'), about_path(resource), target: :_blank
  end

  batch_action :toggle_online, if: proc { can? :toggle_online, About } do |ids|
    About.find(ids).each { |item| item.toggle! :online }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :reset_cache, if: proc { can? :reset_cache, About } do |ids|
    About.find(ids).each(&:touch)
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
    include ActiveAdmin::ParamsHelper
    include ActiveAdmin::Postable
    include ActiveAdmin::Cachable
    include OptionalModules::Videoable
  end
end
