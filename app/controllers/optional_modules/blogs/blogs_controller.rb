# frozen_string_literal: true

#
# == BlogsController
#
class BlogsController < ApplicationController
  include OptionalModules::Bloggable

  before_action :set_blog, only: [:show]
  include OptionalModules::Commentsable

  decorates_assigned :blog, :comment

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.includes_collection.published.order(created_at: :desc)
    per_p = @setting.per_page == 0 ? @blogs.count : @setting.per_page
    @blogs = BlogDecorator.decorate_collection(@blogs.page(params[:page]).per(per_p))
    seo_tag_index category
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    redirect_to blog_category_blog_path(@blog.blog_category, @blog), status: :moved_permanently if request.path_parameters[:id] != @blog.slug
    seo_tag_show blog
  end

  private

  def set_blog
    @blog = Blog.published.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end
end
