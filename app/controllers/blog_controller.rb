#
# == BlogController
#
class BlogController < ApplicationController
  before_action :set_blog, only: [:show]
  decorates_assigned :about, :comment, :element

  # GET /blog
  # GET /blog.json
  def index
    BlogDecorator.decorate_collection(Blog.online.by_locale(@language).page params[:page])
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
