#
# == Posts Controller
#
class PostsController < ApplicationController
  before_action :make_redirect, only: [:feed], unless: proc { @rss_module.enabled? }
  before_action :set_posts, only: [:feed]

  def feed
    respond_to do |format|
      format.atom { render layout: false }
      format.rss { redirect_to posts_rss_path(format: :atom), status: :moved_permanently }
    end
  end

  private

  def make_redirect
    redirect_to root_path
  end

  def set_posts
    @posts = Post.includes(:translations).allowed_for_rss.online
    @posts += Blog.includes(:translations).online if @blog_module.enabled?
    @posts += Event.includes(:translations).online if @event_module.enabled?
    @posts = @posts.sort_by(&:updated_at).reverse
    @updated = @posts.first.updated_at unless @posts.empty?
  end
end
