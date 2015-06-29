#
# == SearchesController
#
class SearchesController < ApplicationController
  def index
    if params[:query].nil? || params[:query].blank?
      @searches = []
    else
      @searches = Post.search(params[:query], params[:locale])

      if @blog_module.enabled?
        @searches += Blog.search(params[:query], params[:locale])
      end

      @searches = Kaminari.paginate_array(@searches).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
