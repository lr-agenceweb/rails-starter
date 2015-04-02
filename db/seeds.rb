#
# == Variables
#
ahora = Time.zone.now

#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
modeles_str = %w(User Setting Setting::Translation Post Post::Translation)
modeles_str.each do |modele_str|
  modele = modele_str.constantize
  modele.destroy_all
  ActiveRecord::Base.connection.execute("ALTER TABLE #{modele.table_name} AUTO_INCREMENT = 1")
end

#
# == Create a default user
#
puts 'Creating users'
User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
)
User.create!(
  email: 'admin2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

#
# == Settings for site
#
puts 'Creating site Setting'
setting_site = Setting.create!(
  name: 'Rails startup',
  title: 'Demo site',
  subtitle: 'démarre rapidement',
  phone: '01 02 03 04 05',
  email: 'demo@startup.fr',
  address: 'Place du Père Noël',
  city: 'Rovaniemi',
  postcode: 96_930,
  geocode_address: 'Père Noël, 96930 Rovaniemi, Finlande',
  latitude: 66.5435,
  longitude: 25.8481,
  show_map: true,
  created_at: ahora,
  updated_at: nil
)

Setting::Translation.create!(
  setting_id: setting_site.id,
  locale: 'en',
  title: 'Demo site',
  subtitle: 'start quickly',
  created_at: ahora,
  updated_at: nil
)

#
# == Home article
#
puts 'Creating Home article'
home = Post.create!(
  type: 'Home',
  title: 'Titre article accueil !',
  slug: 'titre-article-accueil',
  content: '<p>Contenu article accueil</p>',
  online: true,
  created_at: ahora,
  updated_at: nil
)

Post::Translation.create!(
  post_id: home.id,
  locale: 'en',
  title: 'Home article title !',
  slug: 'home-article-title',
  content: '<p>Home article content</p>',
  created_at: ahora,
  updated_at: nil
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
  online: true,
  created_at: ahora,
  updated_at: nil
)

Post::Translation.create!(
  post_id: about.id,
  locale: 'en',
  title: 'About article title !',
  slug: 'about-article-title',
  content: '<p>about article content</p>',
  created_at: ahora,
  updated_at: nil
)

#
# == FriendlyId
#
puts 'Setting Friendly Id'
Post.find_each(&:save)

puts 'Seeds successfuly loaded :)'