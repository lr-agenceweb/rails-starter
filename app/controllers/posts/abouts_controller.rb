#
# == Abouts Controller
#
class AboutsController < PostsController
  decorates_assigned :about
  before_action :set_about, only: [:show, :create]
  before_action :set_commentable, only: [:show]

  # GET /abouts
  # GET /abouts.json
  def index
    @abouts = About.online.includes(:referencement)
    seo_tag_index category
  end

  def show
    seo_tag_show @about
  end

  private

  def set_about
    @about = About.includes(:referencement).friendly.find(params[:id])
    @element = @about
  end

  def set_commentable
    @commentable = @element
    @comments = @commentable.comments.includes(:user).page params[:page]
    @comment = Comment.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:comment, :title, :user_id, :commentable_id, :commentable_type)
  end
end
