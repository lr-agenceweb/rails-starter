#
# == BlogsController
#
class BlogsController < ApplicationController
  before_action :set_blog, only: [:show]
  decorates_assigned :blog, :comment

  # GET /blog
  # GET /blog.json
  def index
    @blogs = BlogDecorator.decorate_collection(Blog.online.page params[:page])
  end

  # GET /blog/1
  # GET /blog/1.json
  def show
  end

  private

  def set_blog
    @blog = Blog.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end
end
