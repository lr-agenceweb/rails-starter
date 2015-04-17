#
# == CommentsController
#
class CommentsController < ApplicationController
  decorates_assigned :comment
  before_action :load_commentable
  before_action :set_comment, only: [:destroy]

  # POST /comments
  # POST /comments.json
  def create
    if comment_params[:nickname].blank?
      @comment = @commentable.comments.new(comment_params)
      @comment.user_id = current_user.id if user_signed_in?

      if @comment.save
        respond_to do |format|
          format.html { redirect_to @commentable, notice: 'Comment was successfully created.' }
          format.js {}
        end
      else
        # Render view user come from instead of the comments default view
        instance_variable_set("@#{@commentable.class.name.underscore}", @commentable)
        @comments = CommentDecorator.decorate_collection(paginate_commentable)
        render "#{@commentable.class.name.underscore.pluralize}/show"
      end
    else # if nickname is filled => robots spam
      respond_to do |format|
        format.html { redirect_to @commentable, notice: 'Captcha caught you' }
        format.js { render 'captcha' }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if can? :destroy, @comment
      if @comment.destroy
        flash.now[:error] = nil
        flash.now[:success] = 'Comment successfully destroy'
        respond_to do |format|
          format.html { redirect_to @commentable }
          format.js {}
        end
      else
        flash.now[:success] = nil
        flash.now[:error] = 'Error trying to destroy comment'
        respond_to do |format|
          format.html { redirect_to @commentable }
          format.js { render 'forbbiden' }
        end
      end
    else
      flash.now[:success] = nil
      flash.now[:error] = 'Your are not allowed to destroy this comment'
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js { render 'forbbiden' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:username, :email, :title, :comment, :user_id, :nickname)
  end

  def load_commentable
    klass = [About].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def paginate_commentable
    @commentable.comments.includes(:user).page params[:page]
  end
end
