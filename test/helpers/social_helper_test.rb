require 'test_helper'

#
# == SocialHelper Test
#
class SocialHelperTest < ActionView::TestCase
  include SocialHelper
  include AssetsHelper
  include HtmlHelper
  include ApplicationHelper
  include MetaTags::ViewHelper
  include Rails.application.routes.url_helpers

  setup :initialize_test

  test 'sould return correct SEO for index page' do
    seo_tag_index(@category.decorate)

    # Basics
    assert_equal meta_tags[:title], 'Accueil'
    assert_equal meta_tags[:description], 'Description pour catégorie home'
    assert_equal meta_tags[:keywords], 'Mots-clés, pour, catégorie, home'

    # Facebook
    assert_equal meta_tags[:og][:title], 'Accueil | Rails Starter, Démarre rapidement'
    assert_equal meta_tags[:og][:description], 'Description pour catégorie home'
    assert_equal meta_tags[:og][:url], root_url
    assert_nil meta_tags[:og][:image]

    # Twitter
    assert_equal meta_tags[:twitter][:title], 'Accueil | Rails Starter, Démarre rapidement'
    assert_equal meta_tags[:twitter][:description], 'Description pour catégorie home'
    assert_equal meta_tags[:twitter][:url], root_url
    assert_nil meta_tags[:twitter][:image]
  end

  test 'sould return correct SEO for show page' do
    seo_tag_show(@about.decorate)

    # Basics
    assert_equal meta_tags[:title], 'Développement et Hébergement'
    assert_equal meta_tags[:description], 'Description pour article À Propos'
    assert_equal meta_tags[:keywords], 'Mots-clés, pour, article, à propos'

    # Facebook
    assert_equal meta_tags[:og][:title], 'Développement et Hébergement | Rails Starter, Démarre rapidement'
    assert_equal meta_tags[:og][:description], 'Description pour article À Propos'
    assert_equal meta_tags[:og][:url], about_url(@about)
    assert_nil meta_tags[:og][:image]

    # Twitter
    assert_equal meta_tags[:twitter][:title], 'Développement et Hébergement | Rails Starter, Démarre rapidement'
    assert_equal meta_tags[:twitter][:description], 'Description pour article À Propos'
    assert_equal meta_tags[:twitter][:url], about_url(@about)
    assert_nil meta_tags[:twitter][:image]
  end

  private

  def initialize_test
    @setting = settings(:one)
    @category = categories(:home)
    @about = posts(:about)
  end
end
