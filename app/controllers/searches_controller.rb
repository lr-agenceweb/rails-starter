#
# == SearchesController
#
class SearchesController < ApplicationController
  def index
    if params[:term].nil? || params[:term].blank?
      @searches = []
    else
      @searches = Post.search(params[:term], params[:locale])

      if @blog_module.enabled?
        @searches += Blog.search(params[:term], params[:locale])
      end

      @not_paginated_searches = @searches
      @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(5)
    end

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end
end
