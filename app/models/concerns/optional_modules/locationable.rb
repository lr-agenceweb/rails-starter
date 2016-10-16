# frozen_string_literal: true

#
# == Module OptionalModules
#
module OptionalModules
  #
  # == Locationable module
  #
  module Locationable
    extend ActiveSupport::Concern

    included do
      has_one :location, as: :locationable, dependent: :destroy
      accepts_nested_attributes_for :location,
                                    reject_if: :all_blank,
                                    allow_destroy: true

      delegate :address, :postcode, :city,
               :latitude, :longitude, :latlon?,
               to: :location, prefix: true, allow_nil: true
    end
  end
end
