# frozen_string_literal: true

#
# UserRole Model
# ================
class Role < ApplicationRecord
  # Model relations
  has_many :users

  # Scopes
  scope :except_super_adminstrator, -> { where.not(name: 'super_administrator') }

  def self.allowed_roles_for_user_role(user)
    if user.super_administrator?
      all.collect { |c| [I18n.t("role.#{c.name}"), c.id] }
    elsif user.administrator?
      all.except_super_adminstrator.collect { |c| [I18n.t("role.#{c.name}"), c.id] }
    end
  end
end

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
