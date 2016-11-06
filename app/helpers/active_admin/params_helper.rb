# frozen_string_literal: true

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == Params helper
  #
  module ParamsHelper
    #
    # Permitted params
    # ================
    def general_attributes
      [:id, :online, :show_as_gallery]
    end

    # Post
    def post_attributes
      [translations_attributes: [
        :id, :locale, :title, :slug, :content
      ]]
    end

    def referencement_attributes
      [referencement_attributes: [
        :id,
        translations_attributes: [
          :id, :locale, :title, :description, :keywords
        ]
      ]]
    end

    def heading_attributes
      [heading_attributes: [
        :id,
        translations_attributes: [
          :id, :locale, :content
        ]
      ]]
    end

    def publication_date_attributes
      [publication_date_attributes: [
        :id, :published_later, :expired_prematurely, :published_at, :expired_at
      ]]
    end

    # Assets
    def picture_attributes(many = false)
      ["picture#{many ? 's' : ''}_attributes": [
        :id, :locale, :image, :online, :position, :_destroy
      ]]
    end

    def background_attributes
      [background_attributes: [
        :id, :image, :_destroy
      ]]
    end

    def video_upload_attributes(many = false)
      ["video_upload#{many ? 's' : ''}_attributes": [
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
    end

    def video_platform_attributes(many = false)
      ["video_platform#{many ? 's' : ''}_attributes": [
        :id, :url, :online, :position, :_destroy
      ]]
    end

    def audio_attributes
      [audio_attributes: [
        :id, :audio, :online, :audio_autoplay, :_destroy
      ]]
    end

    def slider_attributes
      [:animate, :autoplay, :time_to_show, :hover_pause, :looper, :navigation, :bullet]
    end

    def slides_attributes
      [slides_attributes: [
        :id, :image, :online, :position, :_destroy,
        translations_attributes: [
          :id, :locale, :title, :description
        ]
      ]]
    end

    # Misc
    def link_attributes
      [link_attributes: [
        :id, :url, :_destroy
      ]]
    end

    def location_attributes
      [location_attributes: [
        :id, :address, :city, :postcode, :geocode_address, :latitude, :longitude, :_destroy
      ]]
    end
  end
end
