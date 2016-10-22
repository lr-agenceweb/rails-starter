# frozen_string_literal: true

#
# == Connection articles
#
puts 'Creating Connection articles'
5.times do |i|
  connection = Connection.new(
    title: set_title,
    content: "<p>#{Faker::Lorem.sentence(1)}</p>",
    show_as_gallery: true,
    online: true,
    user_id: @administrator.id
  )
  connection.save(validate: false)

  if @locales.include?(:en)
    Connection::Translation.create!(
      post_id: connection.id,
      locale: 'en',
      title: set_title,
      content: "<p>#{Faker::Lorem.sentence(1)}</p>",
    )
  end

  # Link
  Link.create!(
    linkable_id: connection.id,
    linkable_type: 'Post',
    url: Faker::Internet.url
  )

  # Picture
  url = Faker::Avatar.image(Faker::Internet.slug, '50x50')
  set_picture(connection, 'Post', url)

  # Referencement
  set_referencement(connection, 'Post')
end
