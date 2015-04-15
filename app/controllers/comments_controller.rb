#
# == CommentsController
#
class CommentsController < ApplicationController
  decorates_assigned :comment
  before_action :load_commentable

  def index
    @comments = CommentDecorator.decorate_collection(@commentable.comments.page params[:page])
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id if user_signed_in?

    if @comment.save
      redirect_to @commentable, notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:username, :email, :title, :comment, :user_id)
  end

  def load_commentable
    klass = [About].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end
end
