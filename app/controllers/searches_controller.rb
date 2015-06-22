#
# == SearchesController
#
class SearchesController < ApplicationController
  def index
    if params[:query].nil? || params[:query].blank?
      @posts = []
    else
      @posts = Post.search(params[:query], params[:locale]).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
