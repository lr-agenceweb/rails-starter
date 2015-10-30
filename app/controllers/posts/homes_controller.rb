#
# == Home Controller
#
class HomesController < PostsController
  decorates_assigned :home

  # GET /homes
  # GET /homes.json
  def index
    @homes = HomeDecorator.decorate_collection(Home.includes(:translations).online.by_position)
    seo_tag_index category

    respond_to do |format|
      format.html
      format.json { render json: @homes }
    end
  end

  def easter_egg
    redirect_to root_path unless request.xhr?
    @asocial = true
    render layout: false
  end
end
