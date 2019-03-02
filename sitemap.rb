require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://sanatik.ir'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily', :priority => 0.9
  add '/advertisements', :changefreq => 'daily', :priority => 0.8
  add '/faqs', :changefreq => 'monthly'
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
