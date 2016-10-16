# frozen_string_literal: true

#
# == SearchesController
#
class SearchesController < ApplicationController
  before_action :search_module_enabled?
  before_action :set_searches

  # GET /rechercher
  # GET /rechercher.json
  def index
    search_action
  end

  # GET /rechercher/autocomplete
  # GET /rechercher/autocomplete.json
  def autocomplete
    search_action(true)
  end

  private

  def search_module_enabled?
    not_found unless @search_module.enabled?
  end

  def search_action(redirect = false)
    @not_paginated_searches = @searches
    @searches.map!(&:decorate)
    @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(5)

    respond_to do |format|
      format.html do
        seo_tag_index category
        render :index
      end
      format.js { render :index, locals: { redirect: redirect } }
      format.json { render :index }
    end
  end

  def set_searches
    @searches = []
    term = params[:term]
    return if term.blank?

    @searches += Post.search(term, params[:locale])
    @searches += Blog.search(term, params[:locale]) if @blog_module.enabled?
    @searches += Event.search(term, params[:locale]) if @event_module.enabled?
  end
end
