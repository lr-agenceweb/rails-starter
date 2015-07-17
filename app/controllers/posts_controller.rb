#
# == Posts Controller
#
class PostsController < InheritedResources::Base
  before_action :set_posts, only: [:feed]

  def feed
    respond_to do |format|
      format.atom { render layout: false }
      format.rss { redirect_to posts_rss_path(format: :atom), status: :moved_permanently }
    end
  end

  private

  def set_posts
    @posts = Post.online.where.not(type: 'Home')
    @posts += Blog.online if @blog_module.enabled?
    @posts = @posts.sort_by(&:updated_at).reverse
    @updated = @posts.first.updated_at unless @posts.empty?
  end
end
