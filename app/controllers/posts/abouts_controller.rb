#
# == Abouts Controller
#
class AboutsController < PostsController
  decorates_assigned :about, :comment
  before_action :set_about, only: [:show, :create]
  before_action :set_commentable, only: [:show]

  # GET /abouts
  # GET /abouts.json
  def index
    @abouts = About.online.includes(:translations)
    seo_tag_index category
  end

  def show
    seo_tag_show @about
  end

  private

  def set_about
    @about = About.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end

  def set_commentable
    @commentable = instance_variable_get("@#{controller_name.singularize}")
    @comments = @commentable.comments.includes(:user).page params[:page]
    @comments = CommentDecorator.decorate_collection(@comments)
    @comment = Comment.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:comment, :title, :user_id, :commentable_id, :commentable_type)
  end
end
