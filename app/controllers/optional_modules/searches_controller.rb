# frozen_string_literal: true

#
# SearchesController
# ======================
class SearchesController < ApplicationController
  before_action :search_module_enabled?
  before_action :set_searches_array_and_term
  before_action :set_searches,
                unless: proc { @term.blank? }
  before_action :search_action

  # GET /rechercher
  # GET /rechercher.json
  def index; end

  # GET /rechercher/autocomplete
  # GET /rechercher/autocomplete.json
  def autocomplete; end

  private

  def search_module_enabled?
    not_found unless @search_module.enabled?
  end

  def set_searches_array_and_term
    @searches = []
    @term = params[:term]
  end

  def set_searches
    @searches += Post.includes(:picture).online.search(@term, params[:locale])
    @searches += Event.includes(:picture).online.search(@term, params[:locale]) if @event_module.enabled?
    @searches += Blog.includes(:picture, blog_category: [:translations]).published.search(@term, params[:locale]) if @blog_module.enabled?
  end

  def search_action
    @searches.map!(&:decorate)
    @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(5)

    respond_to do |format|
      format.html do
        seo_tag_index page
        render :index
      end
      format.js { render :index, locals: { redirect: params[:action] == 'index' ? false : true } }
      format.json { render :index }
    end
  end
end
