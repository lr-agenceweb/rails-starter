#
# == SearchesController
#
class SearchesController < ApplicationController
  before_action :search_module_enabled?

  # GET /rechercher
  # GET /rechercher.json
  def index
    if params[:term].nil? || params[:term].blank? || params[:term].length < 3
      @searches = []
    else
      @searches = Post.search(params[:term], params[:locale])

      if @blog_module.enabled?
        @searches += Blog.search(params[:term], params[:locale])
      end

      if @event_module.enabled?
        @searches += Event.search(params[:term], params[:locale])
      end

      @not_paginated_searches = @searches
      @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(5)
    end

    respond_to do |format|
      format.html { seo_tag_index category }
      format.js
      format.json
    end
  end

  private

  def search_module_enabled?
    not_found unless @search_module.enabled?
  end
end