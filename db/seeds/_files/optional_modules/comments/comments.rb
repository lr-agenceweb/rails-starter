# frozen_string_literal: true

#
# == Comment
#
puts 'Creating Comments'
Comment.create!(
  username: 'John',
  email: 'john@test.com',
  comment: 'Très bon article !',
  lang: 'fr',
  validated: true,
  commentable_id: @blog.id,
  commentable_type: 'Blog',
  user_id: nil
)
Comment.create!(
  username: nil,
  email: nil,
  comment: 'Article très intéressant, merci !',
  lang: 'fr',
  validated: true,
  commentable_id: @blog.id,
  commentable_type: 'Blog',
  user_id: @administrator.id
)
