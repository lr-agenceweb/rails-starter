# frozen_string_literal: true

#
# == Create user roles
#
puts 'Creating user roles'
roles = %w( super_administrator administrator subscriber )

roles.each do |role|
  Role.create!(name: role)
end
