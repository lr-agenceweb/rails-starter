require 'test_helper'

#
# == CategoryDecorator test
#
class CategoryDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should return correct menu title' do
    assert_equal 'Accueil', @category_decorated.title_d
  end

  test 'should return correct value for background_deco' do
    assert_equal 'Pas de Background associé', @category_decorated.background_deco

    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @category_about_decorated.background.update_attributes(image: attachment)
    assert_equal "<img width=\"300\" height=\"169\" src=\"#{@category_about_decorated.background.image.url(:small)}\" alt=\"Small background paris\" />", @category_about_decorated.background_deco
  end

  test 'should return correct value for div_color' do
    assert_equal '<div style="background-color: #F0F; width: 35px; height: 20px;"></div>', @category_decorated.div_color
    assert_equal '<span>Pas de couleur</span>', @category_about_decorated.div_color
  end

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal "Page \"Accueil\"", @category_decorated.title_aa_show
    assert_equal "Page \"A Propos\"", @category_about_decorated.title_aa_show
  end

  test 'should return correct AA edit page title' do
    assert_equal "Modifier page \"Accueil\"", @category_decorated.title_aa_edit
    assert_equal "Modifier page \"A propos\"", @category_about_decorated.title_aa_edit
  end

  #
  # == Videos
  #
  test 'should return video preview' do
    attachment = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @category_decorated.video_upload.update_attributes(video_file: attachment)

    assert_equal "<img src=\"#{Figaro.env.loader_spinner_img}\" alt=\"Spinner\" />", @category_decorated.video_preview
  end

  test 'should return boolean for video? if no video' do
    assert_not @category_about_decorated.video?
  end

  test 'should return boolean for video? if video' do
    attachment = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @category_decorated.video_upload.update_attributes(video_file: attachment)
    assert_not @category_decorated.video?
    @category_decorated.video_upload.update_attribute(:video_file_processing, false)
    assert @category_decorated.video?
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for basic module' do
    assert_match "<span class=\"status_tag module_de_base\">Module De Base</span>", @category_decorated.module
  end

  test 'should return correct status_tag for enabled module' do
    assert_match "<span class=\"status_tag module_activé blue\">Module Activé</span>", @category_blog_decorated.module
  end

  test 'should return correct status_tag for disabled module' do
    @blog_module.update_attribute(:enabled, false)
    assert_match "<span class=\"status_tag module_non_activé red\">Module Non Activé</span>", @category_blog_decorated.module
  end

  private

  def initialize_test
    @category = categories(:home)
    @category_about = categories(:about)
    @category_blog = categories(:blog)

    @blog_module = optional_modules(:blog)

    @category_decorated = CategoryDecorator.new(@category)
    @category_about_decorated = CategoryDecorator.new(@category_about)
    @category_blog_decorated = CategoryDecorator.new(@category_blog)
  end
end
