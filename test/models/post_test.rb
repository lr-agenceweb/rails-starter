require 'test_helper'

#
# == Post model test
#
class PostTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return only RSS articles' do
    rss_items = Post.allowed_for_rss.online
    expected = []
    not_expected = ["Article d'accueil", "Développement et Hébergement", "Mes mentions légales", "Hébergement"]

    expected_in_rss(expected, rss_items)
    not_expected_in_rss(not_expected, rss_items)
  end

  private

  def initialize_test
    @menu_home = menus(:home)
    @event_module = optional_modules(:event)
  end

  def expected_in_rss(expected, rss_items)
    expected.each do |item|
      assert rss_items.map(&:title).include?(item), "\"#{item}\" should be included in menu"
    end
  end

  def not_expected_in_rss(not_expected, rss_items)
    not_expected.each do |item|
      assert_not rss_items.map(&:title).include?(item), "\"#{item}\" should not be included in menu"
    end
  end
end
