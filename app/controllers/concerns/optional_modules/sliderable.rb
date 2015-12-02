#
# == SliderableConcern
#
module Sliderable
  extend ActiveSupport::Concern

  included do
    before_action :set_slider, if: proc { @slider_module.enabled? }
    decorates_assigned :slider

    def set_slider
      @slider = Slider.includes(slides: [:translations]).online.by_page(controller_name.classify).first
    end
  end
end
