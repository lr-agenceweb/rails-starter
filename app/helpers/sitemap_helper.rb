#
# == SitemapHelper
#
module SitemapHelper
  def classic_links
    add root_path
    add abouts_path, priority: 0.7, changefreq: 'monthly'
    add new_contact_path, priority: 0.7, changefreq: 'monthly'
  end

  def blog_module
    add blogs_path, priority: 0.7, changefreq: 'monthly'
    Blog.online.find_each do |blog|
      add blog_path(blog), priority: 0.7, changefreq: 'monthly'
    end
  end

  def event_module
    add events_path, priority: 0.7, changefreq: 'monthly'
    Event.online.find_each do |event|
      add event_path(event), priority: 0.7, changefreq: 'monthly'
    end
  end

  def guest_book_module
    add guest_books_path, priority: 0.7, changefreq: 'monthly'
  end

  def rss_module
    add posts_rss_path(format: :atom), priority: 0.7, changefreq: 'monthly'
  end
end
