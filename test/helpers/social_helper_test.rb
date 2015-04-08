require 'test_helper'

#
# == SocialHelper Test
#
class SocialHelperTest < ActionView::TestCase
  include SocialHelper
  include AssetsHelper
  include ApplicationHelper
  include MetaTags::ViewHelper
  include Rails.application.routes.url_helpers

  test 'sould return correct SEO for index page' do
    @category = categories(:home)
    seo_tag_index(@category.decorate)

    # Basics
    assert_equal meta_tags[:title], 'Accueil'
    assert_equal meta_tags[:description], 'Description pour catégorie home'
    assert_equal meta_tags[:keywords], 'Mots-clés, pour, catégorie, home'

    # Facebook
    assert_equal meta_tags[:og][:title], 'Accueil'
    assert_equal meta_tags[:og][:description], 'Description pour catégorie home'
    assert_equal meta_tags[:og][:url], root_url
    assert_nil meta_tags[:og][:image]

    # Twitter
    assert_equal meta_tags[:twitter][:title], 'Accueil'
    assert_equal meta_tags[:twitter][:description], 'Description pour catégorie home'
    assert_equal meta_tags[:twitter][:url], root_url
    assert_nil meta_tags[:twitter][:image]
  end
end
