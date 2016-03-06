#
# == BlogsController
#
class BlogsController < ApplicationController
  before_action :blog_module_enabled?
  before_action :set_blog, only: [:show]
  before_action :set_last_blogs, only: [:index]
  decorates_assigned :blog, :comment

  include Commentable

  # GET /blog
  # GET /blog.json
  def index
    @blogs = Blog.includes(:translations, :user).online.order(created_at: :desc)
    per_p = @setting.per_page == 0 ? @blogs.count : @setting.per_page
    @blogs = BlogDecorator.decorate_collection(@blogs.page(params[:page]).per(per_p))
    seo_tag_index category
  end

  # GET /blog/1
  # GET /blog/1.json
  def show
    redirect_to @blog, status: :moved_permanently if request.path_parameters[:id] != @blog.slug
    @blog_settings = BlogSetting.first
    seo_tag_show blog
  end

  private

  def set_blog
    @blog = Blog.online.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end

  def set_last_blogs
    @last_blogs = Blog.select(:id, :title, :updated_at).includes(:comments, :translations).online.order('created_at DESC').last(5)
  end

  def blog_module_enabled?
    not_found unless @blog_module.enabled?
  end
end
