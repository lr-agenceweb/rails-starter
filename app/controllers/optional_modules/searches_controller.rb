# frozen_string_literal: true
#
# == SearchesController
#
class SearchesController < ApplicationController
  before_action :search_module_enabled?

  # GET /rechercher
  # GET /rechercher.json
  def index
    search_action
  end

  # GET /rechercher/autocomplete
  # GET /rechercher/autocomplete.json
  def autocomplete
    search_action
  end

  private

  def search_module_enabled?
    not_found unless @search_module.enabled?
  end

  def search_action
    if render_empty_array?
      @searches = []
    else
      set_search_array
      @not_paginated_searches = @searches
      @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(5)
    end

    respond_to do |format|
      format.html do
        seo_tag_index category
        render :index
      end
      format.js { render :index }
      format.json { render :index }
    end
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
