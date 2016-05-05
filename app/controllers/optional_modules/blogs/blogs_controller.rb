# frozen_string_literal: true

#
# == BlogsController
#
class BlogsController < ApplicationController
  include OptionalModules::Bloggable
  include Commentable

  before_action :set_blog, only: [:show]
  decorates_assigned :blog, :comment

  # GET /blog
  # GET /blog.json
  def index
    @blogs = Blog.includes(:translations, :user, :picture, :video_uploads, :video_platforms, blog_category: [:translations]).online.order(created_at: :desc)
    per_p = @setting.per_page == 0 ? @blogs.count : @setting.per_page
    @blogs = BlogDecorator.decorate_collection(@blogs.page(params[:page]).per(per_p))
    seo_tag_index category
  end

  # GET /blog/1
  # GET /blog/1.json
  def show
    redirect_to @blog, status: :moved_permanently if request.path_parameters[:id] != @blog.slug
    seo_tag_show blog
  end

  private

  def set_blog
    @blog = Blog.online.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end
end
