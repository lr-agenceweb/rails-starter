# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer
#  locationable_type :string(255)
#  address           :string(255)
#  city              :string(255)
#  postcode          :integer
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

#
# == Location Model
#
class Location < ActiveRecord::Base
  belongs_to :locationable, polymorphic: true
end
