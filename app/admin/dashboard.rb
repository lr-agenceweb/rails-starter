# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1,
       label: proc {
         I18n.t('active_admin.dashboard')
       }

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Variables
    # TODO: Find a way to clean this (use before_action or setup concern) => same code as RSS
    @posts = []
    @posts += Post.includes(:translations).order(id: :desc).allowed_for_rss.last(3)
    @posts += Blog.includes(:translations, blog_category: [:translations]).published.last(3) if OptionalModule.find_by(name: 'Blog').enabled?
    @posts += Event.includes(:translations).online.last(3) if OptionalModule.find_by(name: 'Event').enabled?
    @posts.sort_by!(&:updated_at).reverse

    # Subscriber
    if current_user.subscriber?
      columns do
        column do |panel|
          render 'posts', panel: panel, query: @posts
        end
      end # columns

      if OptionalModule.find_by(name: 'Comment').enabled?
        columns do
          column do |panel|
            render 'comments', panel: panel, query: Comment.includes(:commentable).by_user(current_user.id).last(5)
          end
        end # columns
      end

      columns do
        column do |panel|
          render 'user', panel: panel, query: [User.includes(:role).find(current_user.id)]
        end
      end # columns

    # Admin / SuperAdmin
    else
      columns do
        # Left
        column do |panel|
          # Posts
          render 'posts', panel: panel, query: @posts

          # Pages
          render 'categories', panel: panel, query: Category.includes(:background, menu: [:translations]) if current_user.super_administrator?
        end # column

        # Right
        column do |panel|
          # Comments
          render 'comments', panel: panel, query: Comment.includes(:commentable).order(id: :desc).last(5) if OptionalModule.find_by(name: 'Comment').enabled?

          # Settings
          render 'settings', panel: panel, query: Setting.first

          # Users
          query = User.includes(:role).order(id: :desc).last(5) unless current_user.administrator?
          query = User.includes(:role).except_super_administrator.order(id: :desc).last(5) if current_user.administrator?
          render 'user', panel: panel, query: query

          # Mapbox
          panel('Mapbox') { render 'elements/map' } unless location.nil?
        end
      end # columns

      columns do
        column do |panel|
          render 'optional_modules', panel: panel, query: OptionalModule.all
        end # column
      end # columns
    end # if / else
  end # content

  controller do
    before_action :set_setting

    private

    def set_setting
      @setting = Setting.first
    end
  end
end
