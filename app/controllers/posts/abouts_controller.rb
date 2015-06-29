#
# == Abouts Controller
#
class AboutsController < PostsController
  before_action :set_about, only: [:show]
  decorates_assigned :about, :comment, :element

  include Commentable

  # GET /abouts
  # GET /abouts.json
  def index
    @abouts = About.online.includes(:translations)
    seo_tag_index category
  end

  def show
    # seo_tag_show @about
  end

  private

  def set_about
    @about = About.includes(:pictures, referencement: [:translations]).friendly.find(params[:id])
  end
end
