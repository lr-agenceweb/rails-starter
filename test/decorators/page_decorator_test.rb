# frozen_string_literal: true
require 'test_helper'

#
# == PageDecorator test
#
class PageDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should return correct menu title' do
    assert_equal 'Accueil', @page_decorated.title_d
  end

  test 'should return correct value for div_color' do
    assert_equal '<div style="background-color: #F0F; width: 35px; height: 20px;"></div>', @page_decorated.div_color
    assert_equal '<span>Pas de couleur</span>', @page_about_decorated.div_color
  end

  #
  # == Heading
  #
  test 'should return correct boolean value for heading?' do
    assert @page_blog_decorated.heading?
    assert_not @page_decorated.heading?
  end

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Page "Accueil"', @page_decorated.title_aa_show
    assert_equal 'Page "A Propos"', @page_about_decorated.title_aa_show
  end

  test 'should return correct AA edit page title' do
    assert_equal 'Modifier page "Accueil"', @page_decorated.title_aa_edit
    assert_equal 'Modifier page "A propos"', @page_about_decorated.title_aa_edit
  end

  #
  # == Cover
  #
  test 'should return correct cover_preview' do
    assert @page.background?
    assert_equal retina_image_tag(@page.background, :image, :medium), @page_decorated.cover_preview
  end

  #
  # == Background
  #
  test 'should return background preview' do
    assert_equal retina_image_tag(@page_decorated.background, :image, :medium), @page_decorated.background_preview
  end

  #
  # == Videos
  #
  test 'should return video preview' do
    attachment = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @page_decorated.video_upload.update_attributes(video_file: attachment)

    assert_match(/<img src=/, @page_decorated.video_preview)
    assert_match(/loader-dark/, @page_decorated.video_preview)
  end

  test 'should return boolean for video? if no video' do
    assert_not @page_about_decorated.video?
  end

  test 'should return boolean for video? if video' do
    attachment = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @page_decorated.video_upload.update_attributes(video_file: attachment)
    assert_not @page_decorated.video?
    @page_decorated.video_upload.update_attribute(:video_file_processing, false)
    assert @page_decorated.video?
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for basic module' do
    assert_match '<span class="status_tag module_de_base">Module De Base</span>', @page_decorated.module
  end

  test 'should return correct status_tag for enabled module' do
    assert_match '<span class="status_tag module_activé blue">Module Activé</span>', @page_blog_decorated.module
  end

  test 'should return correct status_tag for disabled module' do
    @blog_module.update_attribute(:enabled, false)
    assert_match '<span class="status_tag module_non_activé red">Module Non Activé</span>', @page_blog_decorated.module
  end

  private

  def initialize_test
    @page = pages(:home)
    @page_about = pages(:about)
    @page_blog = pages(:blog)

    @blog_module = optional_modules(:blog)

    @page_decorated = PageDecorator.new(@page)
    @page_about_decorated = PageDecorator.new(@page_about)
    @page_blog_decorated = PageDecorator.new(@page_blog)
  end
end
