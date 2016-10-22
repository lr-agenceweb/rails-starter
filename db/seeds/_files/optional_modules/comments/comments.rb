# frozen_string_literal: true

#
# == Comment
#
puts 'Creating Comments for Blog'
30.times do |i|
  c = Comment.create!(
    username: Faker::Internet.user_name,
    email: Faker::Internet.free_email,
    comment: Faker::Lorem.paragraph(2, true),
    lang: I18n.available_locales.sample,
    commentable_id: Blog.all.map(&:id).sample,
    commentable_type: 'Blog',
    user_id: nil
  )
  c.toggle!(:validated)
end

10.times do |i|
  comment = Comment.validated.sample
  c = Comment.create!(
    username: nil,
    email: nil,
    comment: Faker::Lorem.paragraph(2, true),
    lang: comment.lang,
    commentable_id: comment.commentable.id,
    commentable_type: 'Blog',
    parent_id: comment.id,
    user_id: @administrator.id
  )
  c.toggle!(:validated)
end
