# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == UserRole Model
# - Handle role for a user (admin, ...)
#
class Role < ActiveRecord::Base
  has_one :user
end
