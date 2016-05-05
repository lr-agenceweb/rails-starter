# frozen_string_literal: true

#
# == SitemapHelper
#
module SitemapHelper
  def classic_links
    add root_path
    add abouts_path, priority: 0.7, changefreq: 'monthly' if Category.find_by(name: 'About').menu_online
    add new_contact_path, priority: 0.7, changefreq: 'monthly' if Category.find_by(name: 'Contact').menu_online
    add legal_notices_path, priority: 0.7, changefreq: 'monthly' if Category.find_by(name: 'LegalNotice').menu_online
  end

  [Blog, Event].each do |mod|
    define_method "#{mod.to_s.underscore}_module" do
      add send("#{mod.to_s.underscore.pluralize}_path"), priority: 0.7, changefreq: 'monthly'
      mod.online.find_each do |resource|
        if resource.is_a?(Blog)
          add blog_category_blog_path(resource.blog_category, resource)
        else
          add send("#{mod.to_s.underscore}_path", resource), priority: 0.7, changefreq: 'monthly'
        end
      end
    end
  end

  def guest_book_module
    add guest_books_path, priority: 0.7, changefreq: 'monthly'
  end

  def rss_module
    add posts_rss_path(format: :atom), priority: 0.7, changefreq: 'monthly'
  end
end
