SitemapGenerator::Interpreter.send :include, SitemapHelper

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Figaro.env.application_host
SitemapGenerator::Sitemap.verbose = true
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.sitemaps_path = 'shared/'

SitemapGenerator::Sitemap.create do
  group(sitemaps_path: 'sitemap/fr/', filename: :french) do
    classic_links
    blog_module if OptionalModule.by_name('Blog').enabled?
    event_module if OptionalModule.by_name('Event').enabled?
    guest_book_module if OptionalModule.by_name('GuestBook').enabled?
    rss_module if OptionalModule.by_name('RSS').enabled?
  end

  if I18n.available_locales.include?(:en)
    group(sitemaps_path: 'sitemap/en/', filename: :english) do
      I18n.with_locale(:en) do
        classic_links
        blog_module if OptionalModule.by_name('Blog').enabled?
        event_module if OptionalModule.by_name('Event').enabled?
        guest_book_module if OptionalModule.by_name('GuestBook').enabled?
        rss_module if OptionalModule.by_name('RSS').enabled?
      end
    end
  end
end
