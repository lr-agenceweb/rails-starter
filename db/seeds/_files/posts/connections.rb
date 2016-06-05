# frozen_string_literal: true

#
# == Connection articles
#
puts 'Creating Connection article'
connection_title_fr = [
  'Grafikart :: développeur web !'
]
connection_title_en = [
  'Grafikart :: web developer'
]
connection_slug_fr = [
  'grafikart-developpeur-web'
]
connection_slug_en = [
  'grafikart-web-developer'
]
connection_content_fr = [
  '<p>Visitez le site de Grafikart !</p>'
]
connection_content_en = [
  '<p>Visit Grafikart website !</p>'
]
connection_user_id = [
  @administrator.id
]
connection_links = [
  'http://grafikart.fr'
]
connection_pictures = [
  'grafikart.jpg'
]

connection_title_fr.each_with_index do |_element, index|
  connection = Connection.new(
    title: connection_title_fr[index],
    slug: connection_slug_fr[index],
    content: connection_content_fr[index],
    online: true,
    user_id: connection_user_id[index]
  )
  connection.save(validate: false)

  if @locales.include?(:en)
    ct = Connection::Translation.new(
      post_id: connection.id,
      locale: 'en',
      title: connection_title_en[index],
      slug: connection_slug_en[index],
      content: connection_content_en[index]
    )
    ct.save(validate: false)
  end

  puts 'Creating Connection Link'
  Link.create!(
    linkable_id: connection.id,
    linkable_type: 'Post',
    url: connection_links[index]
  )

  puts 'Creating Connection Picture'
  Picture.create!(
    attachable_id: connection.id,
    attachable_type: 'Post',
    image: File.new("#{Rails.root}/db/seeds/connections/#{connection_pictures[index]}"),
    online: true
  )
end
