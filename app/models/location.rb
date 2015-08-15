#
# == Location Model
#
class Location < ActiveRecord::Base
  belongs_to :locationable, polymorphic: true
end
