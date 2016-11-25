# frozen_string_literal: true

#
# Location Model
# ================
class Location < ApplicationRecord
  # Model relations
  belongs_to :locationable, polymorphic: true, touch: true

  # Validation rules
  validates :address, presence: true
  validates :city, presence: true

  validates :postcode,
            presence: true,
            numericality: { only_integer: true }

  def latlon?
    latitude.present? && longitude.present?
  end
end

# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_type :string(255)
#  locationable_id   :integer
#  address           :string(255)
#  city              :string(255)
#  postcode          :string(255)
#  latitude          :float(24)
#  longitude         :float(24)
#  geocode_address   :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_type_and_locationable_id  (locationable_type,locationable_id)
#
