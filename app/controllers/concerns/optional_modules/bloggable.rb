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
      include ModuleSettingable
      before_action :set_blog_categories, only: [:index, :show]
      before_action :set_last_blogs, only: [:index, :show]
      before_action :set_last_comments, only: [:index, :show], if: proc { @comment_module.enabled? }

      LAST_BLOGS_COUNT ||= 5
      LAST_COMMENTS_COUNT ||= 5

      def blog_module_enabled?
        not_found unless @blog_module.enabled?
      end

      def set_blog_categories
        @blog_categories = BlogCategory.select(:id).includes(:translations).all
      end

      def set_last_blogs
        @last_blogs = Blog.select(:id, :blog_category_id, :updated_at).includes(:comments, :translations, blog_category: [:translations]).published.order('blogs.created_at DESC').first(LAST_BLOGS_COUNT)
      end

      def set_last_comments
        last_comments = Comment.select(:id, :username, :email, :user_id, :commentable_type, :commentable_id).includes(:user, commentable: [:blog_category, :publication_date, :translations]).only_blogs.by_locale(@language).validated.first(LAST_COMMENTS_COUNT).reject { |r| !r.commentable.published? }
        @last_comments = CommentDecorator.decorate_collection(last_comments)
        gon.push(last_comments_count: LAST_COMMENTS_COUNT)
      end
    end
  end
end
