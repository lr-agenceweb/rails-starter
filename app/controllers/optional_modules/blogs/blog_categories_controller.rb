# frozen_string_literal: true

#
# == BlogCategoriesController
#
class BlogCategoriesController < ApplicationController
  include OptionalModules::Bloggable

  before_action :set_blog_category, only: [:show]

  def show
    @blogs = Blog.includes(:translations, :picture, :video_uploads, :video_platforms, :user, referencement: [:translations]).by_category(@blog_category).online.order(created_at: :desc)
    per_p = @setting.per_page == 0 ? @blogs.count : @setting.per_page
    @blogs = BlogDecorator.decorate_collection(@blogs.page(params[:page]).per(per_p))
    seo_tag_index category

    respond_to do |format|
      format.html {}
      format.js { render 'blogs/index' }
    end
  end

  private

  def set_blog_category
    @blog_category = BlogCategory.find(params[:id]) || not_found
  end
end
