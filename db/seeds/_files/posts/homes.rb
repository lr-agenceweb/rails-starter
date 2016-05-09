# frozen_string_literal: true

#
# == Home article
#
puts 'Creating Home article'
home = Post.create!(
  type: 'Home',
  title: 'Bienvenue sur le site !',
  slug: 'bienvenue-sur-le-site',
  content: '<p>Merci de visiter mon site</p>',
  online: true,
  user_id: @administrator.id
)
referencement = Referencement.create!(
  attachable_id: home.id,
  attachable_type: 'Post',
  title: '',
  description: '',
  keywords: ''
)

if @locales.include?(:en)
  Post::Translation.create!(
    post_id: home.id,
    locale: 'en',
    title: 'Welcome to my site',
    slug: 'welcome-to-my-site',
    content: '<p>Thanks to visit my site</p>'
  )
  Referencement::Translation.create!(
    referencement_id: referencement.id,
    locale: 'en',
    title: '',
    description: '',
    keywords: ''
  )
end
