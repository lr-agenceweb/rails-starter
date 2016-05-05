# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == BloggableConcern
  #
  module Bloggable
    extend ActiveSupport::Concern

    included do
      before_action :blog_module_enabled?
      before_action :set_blog_settings, only: [:index, :show]
      before_action :set_blog_categories, only: [:index, :show]
      before_action :set_last_blogs, only: [:index, :show]
      before_action :set_last_comments, only: [:index, :show], if: proc { @comment_module.enabled? }

      def blog_module_enabled?
        not_found unless @blog_module.enabled?
      end

      def set_blog_settings
        @blog_settings = BlogSetting.first
      end

      def set_blog_categories
        @blog_categories = BlogCategory.includes(:translations).all
      end

      def set_last_blogs
        @last_blogs = Blog.select(:id, :title, :blog_category_id, :updated_at).includes(:comments, :translations).online.order('created_at DESC').last(5)
      end

      def set_last_comments
        last_comments = Comment.includes(:user, :commentable).only_blogs.by_locale(@language).validated.last(5).reject { |r| !r.commentable.online? }
        @last_comments = CommentDecorator.decorate_collection(last_comments)
      end
    end
  end
end