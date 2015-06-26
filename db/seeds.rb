#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
modeles_str = %w( User Role Setting Setting::Translation Post Post::Translation Category Category::Translation Referencement Referencement::Translation Newsletter Newsletter::Translation GuestBook )
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
User.create!(
  username: 'superadmin',
  email: 'superadmin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 1
)
# User.create!(
#   username: 'admin',
#   email: 'admin@example.com',
#   password: 'password',
#   password_confirmation: 'password',
#   role_id: 2
# )
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
  subtitle: 'démarre rapidement',
  phone: '01 02 03 04 05',
  email: 'demo@starter.fr',
  address: 'Place du Père Noël',
  city: 'Rovaniemi',
  postcode: 96_930,
  geocode_address: 'Père Noël, 96930 Rovaniemi, Finlande',
  latitude: 66.5435,
  longitude: 25.8481,
  show_map: true
)

Setting::Translation.create!(
  setting_id: setting_site.id,
  locale: 'en',
  title: 'Rails starter',
  subtitle: 'start quickly'
)

#
# == Categories
#
puts 'Creating Menu elements'
title_en = ['Home', 'About', 'Contact', 'Search', 'GuestBook']
title_fr = ['Accueil', 'À Propos', 'Me contacter', 'Recherche', 'Livre d\'Or']
description_en = ['Homepage description', 'About description', 'Contact description', 'Search description', 'GuestBook description']
description_fr = ['Description pour la page d\'accueil', 'Description de la page à propos', 'Description de la page contact', 'Description de la page recherche', 'Description de la page livre d\'or']
keywords_en = ['home', 'about', 'contact', 'search', 'guest book']
keywords_fr = ['accueil', 'à propos', 'contact', 'recherche', 'livre d\'or']
show_in_menu = [true, false, true, true, true]
show_in_footer = [false, false, false, false, false]

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
  title: 'Titre article accueil !',
  slug: 'titre-article-accueil',
  content: '<p>Contenu article accueil</p>',
  online: true
)

Post::Translation.create!(
  post_id: home.id,
  locale: 'en',
  title: 'Home article title !',
  slug: 'home-article-title',
  content: '<p>Home article content</p>'
)

#
# == About article
#
puts 'Creating About article'
about = Post.create!(
  type: 'About',
  title: 'Titre article A propos !',
  slug: 'titre-article-a-propos',
  content: '<p>Contenu article a-propos</p>',
  online: true
)

Post::Translation.create!(
  post_id: about.id,
  locale: 'en',
  title: 'About article title !',
  slug: 'about-article-title',
  content: '<p>about article content</p>'
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
# == FriendlyId
#
puts 'Setting Friendly Id'
User.find_each(&:save)
Post.find_each(&:save)
Newsletter.find_each(&:save)

puts 'Seeds successfuly loaded :)'