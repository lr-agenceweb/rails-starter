# frozen_string_literal: true
require 'test_helper'

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == SocialHelper Test
  #
  class SocialHelperTest < ActionView::TestCase
    include ApplicationHelper
    include Core::PageHelper
    include AssetsHelper
    include HtmlHelper
    include MetaTags::ViewHelper
    include Rails.application.routes.url_helpers

    setup :initialize_test

    test 'sould return correct SEO for index page' do
      seo_tag_index(@page_home.decorate)

      # Basics
      assert_equal 'Accueil', meta_tags[:title]
      assert_equal 'Description pour catégorie home', meta_tags[:description]
      assert_equal 'Mots-clés, pour, catégorie, home', meta_tags[:keywords]

      # Facebook
      assert_equal 'Accueil | Rails Starter, Démarre rapidement', meta_tags[:og][:title]
      assert_equal 'Description pour catégorie home', meta_tags[:og][:description]
      assert_equal root_url, meta_tags[:og][:url]
      assert_nil meta_tags[:og][:image]

      # Twitter
      assert_equal 'Accueil | Rails Starter, Démarre rapidement', meta_tags[:twitter][:title]
      assert_equal 'Description pour catégorie home', meta_tags[:twitter][:description]
      assert_equal root_url, meta_tags[:twitter][:url]
      assert_nil meta_tags[:twitter][:image]
    end

    test 'sould return correct SEO for show page' do
      seo_tag_show(@about.decorate)

      # Basics
      assert_equal 'Développement et Hébergement avec Ruby', meta_tags[:title]
      assert_equal 'Description pour article À Propos', meta_tags[:description]
      assert_equal 'Mots-clés, pour, article, à propos', meta_tags[:keywords]

      # Facebook
      assert_equal 'Développement et Hébergement avec Ruby | Rails Starter, Démarre rapidement', meta_tags[:og][:title]
      assert_equal 'Description pour article À Propos', meta_tags[:og][:description]
      assert_equal about_url(@about), meta_tags[:og][:url]
      assert_nil meta_tags[:og][:image]

      # Twitter
      assert_equal 'Développement et Hébergement avec Ruby | Rails Starter, Démarre rapidement', meta_tags[:twitter][:title]
      assert_equal 'Description pour article À Propos', meta_tags[:twitter][:description]
      assert_equal about_url(@about), meta_tags[:twitter][:url]
      assert_nil meta_tags[:twitter][:image]
    end

    private

    def initialize_test
      @setting = settings(:one)
      @page_home = pages(:home)
      @about = posts(:about)
    end
  end
end
