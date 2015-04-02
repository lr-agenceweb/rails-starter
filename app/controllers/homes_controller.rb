class HomesController < InheritedResources::Base
  # GET /products
  # GET /products.json
  def index
    @home = Home.online.first

    respond_to do |format|
      format.html
      format.json { render json: @home }
    end
  end
end