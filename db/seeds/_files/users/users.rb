# frozen_string_literal: true

#
# == Create a default user
#
puts 'Creating users'
@super_administrator = User.create!(
  username: 'anthony',
  email: 'anthony@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 1
)
@administrator = User.create!(
  username: 'bob',
  email: 'bob@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 2
)
User.create!(
  username: 'abonne',
  email: 'abonne@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 3
)
