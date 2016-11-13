# frozen_string_literal: true

#
# BlogCategoriesController
# ============================
class BlogCategoriesController < ApplicationController
  include OptionalModules::Bloggable

  before_action :set_blog_category, only: [:show]

  def show
    @blogs = Blog.includes_collection.by_category(@blog_category).published.order(created_at: :desc)
    per_p = @setting.per_page == 0 ? @blogs.count : @setting.per_page
    @blogs = BlogDecorator.decorate_collection(@blogs.page(params[:page]).per(per_p))
    seo_tag_index page

    respond_to do |format|
      format.html {}
      format.js { render 'blogs/index' }
    end
  end

  private

  def set_blog_category
    @blog_category = BlogCategory.friendly.find(params[:id]) || not_found
  end
end
