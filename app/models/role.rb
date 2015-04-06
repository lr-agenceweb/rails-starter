#
# == UserRole Model
# - Handle role for a user (admin, ...)
#
class Role < ActiveRecord::Base
  has_one :user
end
