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
    if request.xhr?
      @asocial = true
      render layout: false
    else
      redirect_to root_path
    end
  end
end
