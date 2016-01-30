require 'test_helper'

#
# == SliderDecorator test
#
class SliderDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Slide
  #
  test 'should return page title for slider' do
    assert_equal 'Accueil', @slider_decorated.page
  end

  #
  # == ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal "Slider page Accueil", @slider_decorated.title_aa_show
  end

  test 'should return correct value for time_to_show' do
    assert_equal '5 secondes', @slider_decorated.time_to_show_deco
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag with autoplay enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @slider_decorated.autoplay_deco
  end

  test 'should return correct status_tag with autoplay disabled' do
    @slider.update_attribute(:autoplay, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @slider_decorated.autoplay_deco
  end

  test 'should return correct status_tag with hover_pause enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @slider_decorated.hover_pause_deco
  end

  test 'should return correct status_tag with hover_pause disabled' do
    @slider.update_attribute(:hover_pause, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @slider_decorated.hover_pause_deco
  end

  test 'should return correct status_tag with loop enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @slider_decorated.loop_deco
  end

  test 'should return correct status_tag with loop disabled' do
    @slider.update_attribute(:loop, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @slider_decorated.loop_deco
  end

  test 'should return correct status_tag with navigation enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @slider_decorated.navigation_deco
  end

  test 'should return correct status_tag with navigation disabled' do
    @slider.update_attribute(:navigation, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @slider_decorated.navigation_deco
  end

  test 'should return correct status_tag with bullet enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @slider_decorated.bullet_deco
  end

  test 'should return correct status_tag with bullet disabled' do
    @slider.update_attribute(:bullet, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @slider_decorated.bullet_deco
  end

  private

  def initialize_test
    @slider = sliders(:online)
    @slider_decorated = SliderDecorator.new(@slider)
  end
end
