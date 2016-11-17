# frozen_string_literal: true
require 'test_helper'

#
# Core namespace
# ================
module Core
  #
  # LanguageHelper Test
  # =====================
  class LanguageHelperTest < ActionView::TestCase
    include FontAwesome::Rails::IconHelper

    setup :initialize_test

    test 'should return correct boolean when checking locale' do
      assert current_locale?(:fr)
      assert_not current_locale?(:en)
    end

    test 'should correctly format in html link language' do
      assert_equal '<a class="menu__item__link" href="#">Français <i class="fa fa-check"></i></a>', current_link_language('check', I18n.t("active_admin.globalize.language.#{params[:locale]}"))
    end

    test 'should return correct slug article by locale' do
      assert_equal 'developpement-hebergement-avec-ruby', slug_for_locale(posts(:about), :fr)
      assert_equal 'site-hosting-with-ruby', slug_for_locale(posts(:about), :en)
    end

    private

    def initialize_test
      params[:locale] = :fr

      @locales = I18n.available_locales
      @blog = blogs(:blog_online)
    end
  end
end
