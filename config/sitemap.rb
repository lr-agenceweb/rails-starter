# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Figaro.env.application_host
SitemapGenerator::Sitemap.verbose = true
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.sitemaps_path = 'shared/'

SitemapGenerator::Sitemap.create do
  group(sitemaps_path: 'sitemap/fr/', filename: :french) do
    add root_path
    add abouts_path, priority: 0.7, changefreq: 'monthly'
    add new_contact_path, priority: 0.7, changefreq: 'monthly'
  end

  group(sitemaps_path: 'sitemap/en/', filename: :english) do
    I18n.with_locale(:en) do
      add root_path
      add abouts_path, priority: 0.7, changefreq: 'monthly'
      add new_contact_path, priority: 0.7, changefreq: 'monthly'
    end
  end
end
