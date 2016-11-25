# frozen_string_literal: true

#
# == Create a default user
#
puts 'Creating Users'
@super_administrator = User.create!(
  username: 'anthony',
  email: 'anthony@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 1,
  account_active: true,
  avatar: set_avatar(slug: 'anthony')
)
@administrator = User.create!(
  username: 'bob',
  email: 'bob@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 2,
  avatar: set_avatar(slug: 'bob')
)
User.create!(
  username: 'abonne',
  email: 'abonne@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 3
)
