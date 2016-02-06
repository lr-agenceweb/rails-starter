require 'test_helper'

#
# == VideoPlatformDecorator test
#
class VideoPlatformDecoratorTest < Draper::TestCase
  setup :initialize_test

  test 'should get correct video link' do
    assert_equal '<a target="blank" href="http://www.dailymotion.com/video/x2z92v3">http://www.dailymotion.com/video/x2z92v3</a>', @video_platform_decorated.video_link
  end

  test 'should get correct title' do
    assert_equal "Paysage du jour / Landscape of the day - Étape 20 (Modane Valfréjus > Alpe d'Huez) - Tour de France 2015", @video_platform_decorated.title_d
    @video_platform.update_attribute(:native_informations, false)
    assert_equal 'Vidéo de démo', @video_platform_decorated.title_d
  end

  test 'should get correct description' do
    assert_equal "Paysage du jour / Landscape of the day - Étape 20 (Modane Valfréjus > Alpe d'Huez) - Tour de France 2015 <br />Official Hashtag: #TDF2015 <br />More information on www.letour.com, https://www.facebook.com/letour, https://twitter.com/letour, https://plus.google.com/+LeTourDeFrance <br />© Amaury Sport Organisation - www.aso.fr", @video_platform_decorated.description_d
    @video_platform.update_attribute(:native_informations, false)
    assert_equal 'Je suis une description de test', @video_platform_decorated.description_d
  end

  test 'should get correct preview for video' do
    assert_equal '<img src="http://s2.dmcdn.net/MkYFP/x240-qKj.png" alt="X240 qkj" />', @video_platform_decorated.preview
  end

  #
  # == Status tag
  #
  test 'should return status_tag for enabled native_informations' do
    assert_match "<span class=\"status_tag informations_natives_activées green\">Informations Natives Activées</span>", @video_platform_decorated.native_informations_d
  end

  test 'should return status_tag for disabled native_informations' do
    @video_platform.update_attribute(:native_informations, false)
    assert_match "<span class=\"status_tag informations_natives_désactivées red\">Informations Natives Désactivées</span>", @video_platform_decorated.native_informations_d
  end

  private

  def initialize_test
    @home = posts(:home)
    @video_platform = video_platforms(:one)
    @video_platform_decorated = VideoPlatformDecorator.new(@video_platform)
  end
end
