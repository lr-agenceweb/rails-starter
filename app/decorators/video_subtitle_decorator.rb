#
# == VideoSubtitleDecorator
#
class VideoSubtitleDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all
  decorates_association :posts

  def make_captions
    if model.online
      {
        fr: { src: model.subtitle_fr.url, label: 'Français' },
        en: { src: model.subtitle_en.url, label: 'English' },
      }
    end
  end
end
