#
# == Home Controller
#
class HomesController < PostsController
  include Videoable

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
end
