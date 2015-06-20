#
# == SearchController
#
class SearchController < ApplicationController
  def index
    if params[:query].nil?
      @posts = []
    else
      @posts = Post.search(params[:query], @language).page params[:page]
    end
  end

  respond_to do |format|
    format.html
    format.js
  end
end
