# frozen_string_literal: true
require 'test_helper'

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == ParamsHelper Test
  #
  class ParamsHelperTest < ActionView::TestCase
    setup :initialize_test

    test 'should return correct params for general' do
      expected = [:id, :online, :show_as_gallery]
      assert_equal expected, general_attributes
    end

    test 'should return correct params for post' do
      expected = [translations_attributes: [
        :id, :locale, :title, :slug, :content
      ]]
      assert_equal expected, post_attributes
    end

    test 'should return correct params for referencement' do
      expected = [referencement_attributes: [
        :id,
        translations_attributes: [
          :id, :locale, :title, :description, :keywords
        ]
      ]]
      assert_equal expected, referencement_attributes
    end

    test 'should return correct params for heading' do
      expected = [heading_attributes: [
        :id,
        translations_attributes: [
          :id, :locale, :content
        ]
      ]]
      assert_equal expected, heading_attributes
    end

    test 'should return correct params for publication_date' do
      expected = [publication_date_attributes: [
        :id, :published_later, :expired_prematurely, :published_at, :expired_at
      ]]
      assert_equal expected, publication_date_attributes
    end

    test 'should return correct params for picture (one)' do
      expected = [picture_attributes: [
        :id, :locale, :image, :online, :position, :_destroy
      ]]
      assert_equal expected, picture_attributes
    end

    test 'should return correct params for picture (many)' do
      expected = [pictures_attributes: [
        :id, :locale, :image, :online, :position, :_destroy
      ]]
      assert_equal expected, picture_attributes(true)
    end

    test 'should return correct params for background' do
      expected = [background_attributes: [
        :id, :image, :_destroy
      ]]
      assert_equal expected, background_attributes
    end

    test 'should return correct params for video_upload (one)' do
      expected = [video_upload_attributes: [
        :id, :online, :position,
        :video_file,
        :video_autoplay,
        :video_loop,
        :video_controls,
        :video_mute,
        :_destroy,
        video_subtitle_attributes: [
          :id, :subtitle_fr, :subtitle_en, :online, :delete_subtitle_fr, :delete_subtitle_en
        ]
      ]]
      assert_equal expected, video_upload_attributes
    end

    test 'should return correct params for video_upload (many)' do
      expected = [video_uploads_attributes: [
        :id, :online, :position,
        :video_file,
        :video_autoplay,
        :video_loop,
        :video_controls,
        :video_mute,
        :_destroy,
        video_subtitle_attributes: [
          :id, :subtitle_fr, :subtitle_en, :online, :delete_subtitle_fr, :delete_subtitle_en
        ]
      ]]
      assert_equal expected, video_upload_attributes(true)
    end

    test 'should return correct params for video_platform (one)' do
      expected = [video_platform_attributes: [
        :id, :url, :online, :position, :_destroy
      ]]
      assert_equal expected, video_platform_attributes
    end

    test 'should return correct params for video_platform (many)' do
      expected = [video_platforms_attributes: [
        :id, :url, :online, :position, :_destroy
      ]]
      assert_equal expected, video_platform_attributes(true)
    end

    test 'should return correct params for audio' do
      expected = [audio_attributes: [
        :id, :audio, :online, :audio_autoplay, :_destroy
      ]]
      assert_equal expected, audio_attributes
    end

    test 'should return correct params for link' do
      expected = [link_attributes: [
        :id, :url, :_destroy
      ]]
      assert_equal expected, link_attributes
    end

    test 'should return correct params for locations' do
      expected = [location_attributes: [
        :id, :address, :city, :postcode, :geocode_address, :latitude, :longitude, :_destroy
      ]]
      assert_equal expected, location_attributes
    end

    private

    def initialize_test
      @controller = Admin::HomesController.new
    end
  end
end
