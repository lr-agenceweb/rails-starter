#
# == Posts Controller
#
class PostsController < ApplicationController
  before_action :redirect_to_home, only: [:feed], unless: proc { @rss_module.enabled? }
  before_action :add_posts_to_feed, only: [:feed]
  before_action :add_blogs_to_feed, only: [:feed], if: proc { @blog_module.enabled? }
  before_action :add_events_to_feed, only: [:feed], if: proc { @event_module.enabled? }
  before_action :sort_feed, only: [:feed]

  def feed
    respond_to do |format|
      format.atom { render layout: false }
      format.rss { redirect_to posts_rss_path(format: :atom), status: :moved_permanently }
    end
  end

  private

  def redirect_to_home
    redirect_to root_path
  end

  def add_posts_to_feed
    @posts = Post.includes(:translations).allowed_for_rss.online
  end

  def add_blogs_to_feed
    @posts += Blog.includes(:translations).online
  end

  def add_events_to_feed
    @posts += Event.includes(:translations).online
  end

  def sort_feed
    @posts = @posts.sort_by(&:updated_at).reverse
    @updated = @posts.first.updated_at unless @posts.empty?
  end
end
