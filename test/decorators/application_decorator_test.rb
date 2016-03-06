require 'test_helper'

#
# == ApplicationDecorator test
#
class ApplicationDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Dynamic menu link
  #
  test 'should return correct menu link for pages' do
    assert_equal '/contact', @contact_decorated.menu_link('Contact')
    assert_equal 'http://test.host/contact', @contact_decorated.menu_link('Contact', true)
    assert_equal '/', @contact_decorated.menu_link('Home')
    assert_equal 'http://test.host/', @contact_decorated.menu_link('Home', true)
  end

  #
  # == DateTime
  #
  test 'should return correct created_at format' do
    assert_equal '01 fév. 13h32', @blog_article_decorated.created_at
  end

  #
  # == Paginator
  #
  test 'should return correct decorator class' do
    assert_equal PaginatingDecorator, ApplicationDecorator.collection_decorator_class
  end

  #
  # == Status tag
  #
  test 'should return status_tag if prev_next' do
    @blog_setting.update_attribute(:prev_next, true)
    assert_match '<span class="status_tag activé green">Activé</span>', @blog_setting_decorated.prev_next
  end

  test 'should return status_tag if prev_next disabled' do
    assert_match '<span class="status_tag désactivé red">Désactivé</span>', @blog_setting_decorated.prev_next
  end

  test 'should return status_tag if show_as_gallery' do
    @blog_article.update_attribute(:show_as_gallery, true)
    assert_match '<span class="status_tag activé green">Activé</span>', @blog_article_decorated.show_as_gallery
  end

  test 'should return status_tag if show_as_gallery disabled' do
    assert_match '<span class="status_tag désactivé red">Désactivé</span>', @blog_article_decorated.show_as_gallery
  end

  test 'should return status_tag if online' do
    assert_match '<span class="status_tag en_ligne green">En Ligne</span>', @blog_article_decorated.status
  end

  test 'should return status_tag if offline' do
    @blog_article.update_attribute(:online, false)
    assert_match '<span class="status_tag hors_ligne red">Hors Ligne</span>', @blog_article_decorated.status
  end

  test 'should return status_tag for french language' do
    assert_match '<span class="status_tag français blue">Français</span>', @newsletter_user_decorated.lang
  end

  test 'should return status_tag for english language' do
    @newsletter_user.update_attribute(:lang, 'en')
    assert_match '<span class="status_tag english red">English</span>', @newsletter_user_decorated.lang
  end

  private

  def initialize_test
    @contact = categories(:contact)
    @blog_setting = blog_settings(:one)
    @blog_article = blogs(:blog_online)
    @newsletter_user = newsletter_users(:newsletter_user_fr)

    @blog_setting_decorated = ApplicationDecorator.new(@blog_setting)
    @blog_article_decorated = ApplicationDecorator.new(@blog_article)
    @contact_decorated = ApplicationDecorator.new(@contact)
    @newsletter_user_decorated = ApplicationDecorator.new(@newsletter_user)
  end
end
