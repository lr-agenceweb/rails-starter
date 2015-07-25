#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
modeles_str = %w( User Role Setting Setting::Translation Post Post::Translation Category Category::Translation Referencement Referencement::Translation Newsletter Newsletter::Translation NewsletterUser GuestBook Blog Blog::Translation OptionalModule StringBox StringBox::Translation Picture Picture::Translation )
modeles_str.each do |modele_str|
  modele = modele_str.constantize
  modele.destroy_all
  ActiveRecord::Base.connection.execute("ALTER TABLE #{modele.table_name} AUTO_INCREMENT = 1")
end

#
# == Create user roles
#
puts 'Creating user roles'
roles = %w( super_administrator administrator subscriber )

roles.each do |role|
  Role.create!(name: role)
end

#
# == Create a default user
#
puts 'Creating users'
super_administrator = User.create!(
  username: 'anthony',
  email: 'anthony@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 1
)
administrator = User.create!(
  username: 'bob',
  email: 'bob@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 2
)
# User.create!(
#   username: 'abonne',
#   email: 'abonne@example.com',
#   password: 'password',
#   password_confirmation: 'password',
#   role_id: 3
# )

#
# == Settings for site
#
puts 'Creating site Setting'
setting_site = Setting.create!(
  name: 'Rails starter',
  title: 'Rails starter',
  subtitle: 'Démonstration',
  phone: '01 02 03 04 05',
  email: 'demo@starter.fr'
)

Setting::Translation.create!(
  setting_id: setting_site.id,
  locale: 'en',
  title: 'Rails starter',
  subtitle: 'Demo'
)

#
# == Map
#
puts 'Creating Map'
Map.create!(
  show_map: true,
  address: 'Place du Père Noël',
  city: 'Rovaniemi',
  postcode: 96_930,
  geocode_address: 'Père Noël, 96930 Rovaniemi, Finlande',
  latitude: 66.5435,
  longitude: 25.8481
)

#
# == Categories
#
puts 'Creating Menu elements'
title_en = ['Home', 'About', 'Contact', 'Search', 'GuestBook', 'Blog', 'Events']
title_fr = ['Accueil', 'À Propos', 'Me contacter', 'Recherche', 'Livre d\'Or', 'Blog', 'Événements']
description_en = ['Homepage description', 'About description', 'Contact description', 'Search description', 'GuestBook description', 'Blog description', 'Event description']
description_fr = ['Description pour la page d\'accueil', 'Description de la page à propos', 'Description de la page contact', 'Description de la page recherche', 'Description de la page livre d\'or', 'Description de la page Blog', 'Description de la page événement']
keywords_en = ['home', 'about', 'contact', 'search', 'guest book', 'blog', 'event']
keywords_fr = ['accueil', 'à propos', 'contact', 'recherche', 'livre d\'or', 'blog', 'événement']
show_in_menu = [true, false, true, true, true, true, true]
show_in_footer = [false, false, false, false, false, false, false]

Category.models_name_str.each_with_index do |element, index|
  category = Category.create!(
    name: element,
    title: title_fr[index],
    show_in_menu: show_in_menu[index],
    show_in_footer: show_in_footer[index]
  )
  Category::Translation.create!(
    category_id: category.id,
    locale: 'en',
    title: title_en[index]
  )

  referencement = Referencement.create!(
    attachable_id: category.id,
    attachable_type: 'Category',
    title: title_fr[index],
    description: description_fr[index],
    keywords: keywords_fr[index]
  )
  Referencement::Translation.create!(
    referencement_id: referencement.id,
    locale: 'en',
    title: title_en[index],
    description: description_en[index],
    keywords: keywords_en[index]
  )
end

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
  user_id: administrator.id
)

Post::Translation.create!(
  post_id: home.id,
  locale: 'en',
  title: 'Welcome to my site',
  slug: 'welcome-to-my-site',
  content: '<p>Thanks to visit my site</p>'
)
referencement = Referencement.create!(
  attachable_id: home.id,
  attachable_type: 'Post',
  title: '',
  description: '',
  keywords: ''
)
Referencement::Translation.create!(
  referencement_id: referencement.id,
  locale: 'en',
  title: '',
  description: '',
  keywords: ''
)

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
  user_id: super_administrator.id
)

Post::Translation.create!(
  post_id: about.id,
  locale: 'en',
  title: 'Hosting and realisation',
  slug: 'hosting-and-realisation',
  content: '<p>This website has been developed by Anthony ROBIN</p>'
)
referencement = Referencement.create!(
  attachable_id: about.id,
  attachable_type: 'Post',
  title: '',
  description: '',
  keywords: ''
)
Referencement::Translation.create!(
  referencement_id: referencement.id,
  locale: 'en',
  title: '',
  description: '',
  keywords: ''
)

#
# == Blog article
#
puts 'Creating Blog article'
blog = Blog.create!(
  title: 'Premier article de blog',
  slug: 'premier-article-de-blog',
  content: '<p>Voici le premier article de mon blog</p>',
  online: true,
  user_id: administrator.id
)

Blog::Translation.create!(
  blog_id: blog.id,
  locale: 'en',
  title: 'First blog article',
  slug: 'first-blog-article',
  content: '<p>This is my first blog article !</p>'
)
referencement = Referencement.create!(
  attachable_id: blog.id,
  attachable_type: 'Blog',
  title: '',
  description: '',
  keywords: ''
)
Referencement::Translation.create!(
  referencement_id: referencement.id,
  locale: 'en',
  title: '',
  description: '',
  keywords: ''
)

#
# == Newsletter
#
puts 'Creating Newsletter'
newsletter = Newsletter.create!(
  title: 'Nouveaux contenus sur le site !',
  content: '<p>Trois nouveaux articles ont été publiés sur le site !</p>',
  sent_at: nil
)

Newsletter::Translation.create!(
  newsletter_id: newsletter.id,
  locale: 'en',
  title: 'New content in the website !',
  content: '<p>Three new contents have been published on the website</p>'
)

#
# == Newsletter User
#
puts 'Creating Newsletter User'
NewsletterUser.create!(
  email: 'abonne@test.fr',
  lang: 'fr',
  role: 'subscriber',
  token: 'df6dbd90f13d7c8'
)
NewsletterUser.create!(
  email: 'subscriber@test.en',
  lang: 'en',
  role: 'subscriber',
  token: '5f9a50a21As109Qw'
)

#
# == OptionalModules
#
puts 'Creating OptionalModules'
description = [
  'Module qui affiche un formulaire pour s\abonner à la newsletter et authorise l\'administrateur à envoyer des mails aux abonnés',
  'Module livre d\'or dans lequel les internautes pourront laisser leur avis',
  'Module de recherche sur le site',
  'Module RSS, donne la possibilité aux internautes de s\'abonner aux articles Post et Blog du site',
  'Module de commentaire: permet aux internautes de commenter les articles Post ou de Blog',
  'Module Blog où l\'administrateur peut créer des articles',
  'Module qui affiche une popup demandant aux internet d\'attester qu\'ils sont bien majeurs pour continuer à visiter le site',
  'Module qui affiche slider avec des images défilantes',
  'Module qui gère des événements à venir',
  'Module qui affiche une carte Mapbox sur le site',
]
OptionalModule.list.each_with_index do |element, index|
  OptionalModule.create!(
    name: element,
    description: description[index],
    enabled: true
  )
end

#
# == StringBox
#
puts 'Creating StringBox'
string_box_keys = ['adult_not_validated_popup_content']
string_box_content_fr = [
  'Afin de pouvoir accéder au site, vous devez être majeur. En cliquant sur accepter vous attestez avoir plus de 18 ans.'
]
string_box_content_en = [
  'In order to access the website, you must be adult. By clicking accept, you attest you are over 18 years old.'
]
string_box_keys.each_with_index do |element, index|
  string_box = StringBox.create!(
    key: element,
    title: '',
    content: string_box_content_fr[index]
  )
  StringBox::Translation.create!(
    string_box_id: string_box.id,
    locale: 'en',
    title: '',
    content: string_box_content_en[index]
  )
end

#
# == GuestBook
#
puts 'Creating GuestBook'
GuestBook.create!(
  username: 'leo',
  email: 'leo@test.com',
  content: 'Merci pour votre site !',
  lang: 'fr',
  validated: true
)

#
# == FriendlyId
#
puts 'Setting Friendly Id'
User.find_each(&:save)
Post.find_each(&:save)
Blog.find_each(&:save)
Newsletter.find_each(&:save)

puts 'Seeds successfuly loaded :)'
