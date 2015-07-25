# == Schema Information
#
# Table name: maps
#
#  id              :integer          not null, primary key
#  address         :string(255)
#  city            :string(255)
#  postcode        :integer
#  geocode_address :string(255)
#  latitude        :float(24)
#  longitude       :float(24)
#  show_map        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Map < ActiveRecord::Base
end
