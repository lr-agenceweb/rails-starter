#
# == SearchesController
#
class SearchesController < ApplicationController
  before_action :set_gon_autocomplete

  def index
    if params[:term].nil? || params[:term].blank?
      @searches = []
    else
      @searches = Post.search(params[:term], params[:locale])

      if @blog_module.enabled?
        @searches += Blog.search(params[:term], params[:locale])
      end

      @searches = Kaminari.paginate_array(@searches).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end

  private

  def set_gon_autocomplete
    gon.push(search_path: searches_path(format: :json))
  end
end
