# frozen_string_literal: true

#
# == About article
#
puts 'Creating About article'
about = Post.create!(
  type: 'About',
  title: 'Hébergement et réalisation',
  slug: 'hebergement-et-realisation',
  content: '<p>Le site a été développé par Anthony ROBIN</p>',
  online: true,
  user_id: @super_administrator.id
)
referencement = Referencement.create!(
  attachable_id: about.id,
  attachable_type: 'Post',
  title: '',
  description: '',
  keywords: ''
)

if @locales.include?(:en)
  Post::Translation.create!(
    post_id: about.id,
    locale: 'en',
    title: 'Hosting and realisation',
    slug: 'hosting-and-realisation',
    content: '<p>This website has been developed by Anthony ROBIN</p>'
  )
  Referencement::Translation.create!(
    referencement_id: referencement.id,
    locale: 'en',
    title: '',
    description: '',
    keywords: ''
  )
end

puts 'Creating About picture'
Picture.create!(
  attachable_id: about.id,
  attachable_type: 'Post',
  image: File.new("#{Rails.root}/db/seeds/abouts/hosting.jpg"),
  online: true
)
