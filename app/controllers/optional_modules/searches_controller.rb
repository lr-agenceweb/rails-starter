#
# == SearchesController
#
class SearchesController < ApplicationController
  before_action :search_module_enabled?
  skip_before_action :set_menu_elements, :set_adult_validation, :set_background, :set_newsletter_user, :set_search_autocomplete, :set_slider, :set_social_network, :set_froala_key, :set_map

  # GET /rechercher
  # GET /rechercher.json
  def index
    if render_empty_array?
      @searches = []
    else
      set_search_array
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

  def set_search_array
    @searches = Post.search(params[:term], params[:locale])
    @searches += Blog.search(params[:term], params[:locale]) if @blog_module.enabled?
    @searches += Event.search(params[:term], params[:locale]) if @event_module.enabled?
  end

  def render_empty_array?
    params[:term].blank? || params[:term].length < 3
  end
end
