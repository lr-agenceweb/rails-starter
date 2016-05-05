# frozen_string_literal: true
SitemapGenerator::Interpreter.send :include, SitemapHelper

# Set the host name for URL creation
renv = Rails.env.development? ? '' : "_#{Rails.env}"
application_host = ENV["application_host#{renv}"]
SitemapGenerator::Sitemap.default_host = application_host
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

        blog_module if OptionalModule.by_name('Blog').enabled? && Category.find_by(name: 'Blog').menu_online
        event_module if OptionalModule.by_name('Event').enabled? && Category.find_by(name: 'Event').menu_online
        guest_book_module if OptionalModule.by_name('GuestBook').enabled? && Category.find_by(name: 'GuestBook').menu_online
        rss_module if OptionalModule.by_name('RSS').enabled?
      end
    end
  end
end
