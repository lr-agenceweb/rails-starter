#
# == Abouts Controller
#
class AboutsController < PostsController
  before_action :set_about, only: [:show]
  decorates_assigned :about, :comment

  include Commentable

  # GET /a-propos
  # GET /a-propos.json
  def index
    @abouts = AboutDecorator.decorate_collection(About.online.by_position.includes(:translations))
    seo_tag_index category
  end

  # GET /a-propos/1
  # GET /a-propos/1.json
  def show
    redirect_to @about, status: :moved_permanently if request.path_parameters[:id] != @about.slug
    seo_tag_show about
  end

  private

  def set_about
    @about = About.online.includes(:pictures, referencement: [:translations]).friendly.find(params[:id]) || not_found
  end
end
