# frozen_string_literal: true
SitemapGenerator::Interpreter.send :include, SitemapHelper

# Configuration of sitemap
SitemapGenerator::Sitemap.default_host = Figaro.env.host_name
SitemapGenerator::Sitemap.verbose = true
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.sitemaps_path = ''

SitemapGenerator::Sitemap.create do
  I18n.available_locales.each do |locale|
    filename = 'english'
    filename = 'french' if locale == :fr
    filename = 'spanish' if locale == :es

    group(sitemaps_path: 'sitemap', filename: filename) do
      I18n.with_locale(locale) do
        classic_links

        blog_module if OptionalModule.by_name('Blog').enabled? && Page.find_by(name: 'Blog').menu_online
        event_module if OptionalModule.by_name('Event').enabled? && Page.find_by(name: 'Event').menu_online
        guest_book_module if OptionalModule.by_name('GuestBook').enabled? && Page.find_by(name: 'GuestBook').menu_online
        rss_module if OptionalModule.by_name('RSS').enabled?
      end
    end
  end
end
