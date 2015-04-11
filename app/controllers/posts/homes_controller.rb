#
# == Home Controller
#
class HomesController < PostsController
  decorates_assigned :home

  # GET /homes
  # GET /homes.json
  def index
    @homes = Home.online
    seo_tag_index category

    respond_to do |format|
      format.html
      format.json { render json: @homes }
    end
  end
end
