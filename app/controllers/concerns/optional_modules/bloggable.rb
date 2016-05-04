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
      before_action :set_blog_settings, only: [:show]
      before_action :set_last_blogs, only: [:index, :show]

      def blog_module_enabled?
        not_found unless @blog_module.enabled?
      end

      def set_blog_settings
        @blog_settings = BlogSetting.first
      end

      def set_last_blogs
        @last_blogs = Blog.select(:id, :title, :blog_category_id, :updated_at).includes(:comments, :translations).online.order('created_at DESC').last(5)
      end
    end
  end
end
