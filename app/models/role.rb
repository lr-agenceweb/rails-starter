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
  has_many :users

  scope :except_super_adminstrator, -> { where.not(name: 'super_administrator') }

  def self.allowed_roles_for_user_role(user)
    if user.super_administrator?
      all
    elsif user.administrator?
      all.except_super_adminstrator
    end
  end
end
