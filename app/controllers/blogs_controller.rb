#
# == BlogsController
#
class BlogsController < ApplicationController
  before_action :set_blog, only: [:show]
  before_action :set_commentable, only: [:show]
  decorates_assigned :blog, :comment

  # GET /blog
  # GET /blog.json
  def index
    @blogs = BlogDecorator.decorate_collection(Blog.online.page params[:page])
  end

  # GET /blog/1
  # GET /blog/1.json
  def show
    redirect_to @blog, status: :moved_permanently if request.path != blog_path(@blog)
  end

  private

  def set_blog
    @blog = Blog.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end

  def set_commentable
    @commentable = instance_variable_get("@#{controller_name.singularize}")
    @comments = @commentable.comments.validated.by_locale(@language).includes(:user).page params[:page]
    @comments = CommentDecorator.decorate_collection(@comments)
    @comment = Comment.new
  end
end
