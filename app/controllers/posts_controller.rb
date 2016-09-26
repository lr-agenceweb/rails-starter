# frozen_string_literal: true

#
# == Posts Controller
#
class PostsController < ApplicationController
  before_action :redirect_to_home,
                only: [:feed, :blog, :event],
                unless: proc { @rss_module.enabled? }
  before_action :set_default_posts, only: [:feed, :blog, :event]
  before_action :add_posts_to_feed, only: [:feed]
  before_action :add_blogs_to_feed,
                only: [:feed, :blog],
                if: proc { @blog_module.enabled? }
  before_action :add_events_to_feed,
                only: [:feed, :event],
                if: proc { @event_module.enabled? }
  before_action :sort_feed, only: [:feed, :blog, :event]

  def feed
    feed_respond
  end

  def blog
    feed_respond 'blogs'
  end

  def event
    feed_respond 'events'
  end

  private

  def feed_respond(route = 'posts', action = :feed)
    respond_to do |format|
      format.atom { render layout: false, action: action }
      format.rss { redirect_to send("#{route}_rss_path", format: :atom), status: :moved_permanently }
    end
  end

  def redirect_to_home
    redirect_to root_path
  end

  def set_default_posts
    @posts = []
  end

  def add_posts_to_feed
    @posts += Post.includes(:translations).allowed_for_rss.online
  end

  def add_blogs_to_feed
    @posts += Blog.includes(:translations, blog_category: [:translations]).online
  end

  def add_events_to_feed
    @posts += Event.includes(:translations).online
  end

  def sort_feed
    @posts = @posts.sort_by(&:updated_at).reverse
    @updated = @posts.first.updated_at unless @posts.empty?
  end
end
