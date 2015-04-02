#
# == Home Controller
#
class HomesController < InheritedResources::Base
  # GET /home
  # GET /home.json
  def index
    @homes = Home.online

    respond_to do |format|
      format.html
      format.json { render json: @homes }
    end
  end
end
