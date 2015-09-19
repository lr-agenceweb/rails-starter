@locales = I18n.available_locales

#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

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
User.create!(
  username: 'abonne',
  email: 'abonne@example.com',
  password: 'password',
  password_confirmation: 'password',
  role_id: 3
)

#
# == Settings for site
#
puts 'Creating site Setting'
setting_site = Setting.create!(
  name: 'Rails starter',
  title: 'Rails starter',
  subtitle: 'Site de Démonstration',
  phone: '+33 (0)1 02 03 04 05',
  email: 'demo@starter.fr',
  logo: File.new("#{Rails.root}/public/system/seeds/logo/logo.png")
)

if @locales.include?(:en)
  Setting::Translation.create!(
    setting_id: setting_site.id,
    locale: 'en',
    title: 'Rails starter',
    subtitle: 'Demo website'
  )
end

#
# == Map
#
puts 'Creating Map'
map = Map.create!(
  show_map: true,
  marker_icon: 'park',
  marker_color: '#EE903E'
)

#
# == Location
#
puts 'Creating Map Location'
Location.create!(
  locationable_id: map.id,
  locationable_type: 'Map',
  address: 'Place du Père Noël',
  city: 'Rovaniemi',
  postcode: 96_930,
  geocode_address: 'Père Noël, 96930 Rovaniemi, Finlande',
  latitude: 66.5435,
  longitude: 25.8481
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
  'Module qui gère les différents réseaux sociaux',
  'Module qui affiche un fil d\'ariane sur le site',
  'Module qui affiche un Qrcode pour créer automatiquement un contact sur son smartphone',
  'Module qui propose à l\'administrateur de choisir une image d\'arrière plan pour les pages du site',
  'Module qui affiche un calendrier'
]
OptionalModule.list.each_with_index do |element, index|
  optional_module = OptionalModule.create!(
    name: element,
    description: description[index],
    enabled: true
  )

  @optional_module_search = optional_module if element == 'Search'
  @optional_module_guest_book = optional_module if element == 'GuestBook'
  @optional_module_blog = optional_module if element == 'Blog'
  @optional_module_event = optional_module if element == 'Event'
end

#
# == Menu
#
puts 'Creating Menu elements'
models_name = [:Home, :Search, :GuestBook, :Blog, :Event, :About, :Contact]
title_en = [
  'Home',
  'Search',
  'GuestBook',
  'Blog',
  'Events',
  'About',
  'Contact'
]
title_fr = [
  'Accueil',
  'Recherche',
  'Livre d\'Or',
  'Blog',
  'Événements',
  'À Propos',
  'Me contacter'
]
show_in_header = [
  true,
  true,
  true,
  true,
  true,
  true,
  true
]
show_in_footer = [
  false,
  false,
  false,
  false,
  false,
  false,
  false
]

title_en.each_with_index do |element, index|
  menu = Menu.create!(
    title: title_fr[index],
    show_in_header: show_in_header[index],
    show_in_footer: show_in_footer[index],
    online: true
  )
  if @locales.include?(:en)
    Menu::Translation.create!(
      menu_id: menu.id,
      locale: 'en',
      title: title_en[index]
    )
  end

  @menu_home = menu.id if element == 'Home'
  @menu_search = menu.id if element == 'Search'
  @menu_guest_book = menu.id if element == 'GuestBook'
  @menu_blog = menu.id if element == 'Blog'
  @menu_event = menu.id if element == 'Events'
  @menu_about = menu.id if element == 'About'
  @menu_contact = menu.id if element == 'Contact'
end

#
# == Categories
#
puts 'Creating pages'
description_en = [
  'Homepage description',
  'Search description',
  'GuestBook description',
  'Blog description',
  'Event description',
  'About description',
  'Contact description'
]
description_fr = [
  'Description pour la page d\'accueil',
  'Description de la page recherche',
  'Description de la page livre d\'or',
  'Description de la page Blog',
  'Description de la page événement',
  'Description de la page à propos',
  'Description de la page contact'
]
keywords_en = [
  'home',
  'search',
  'guest book',
  'blog',
  'event',
  'about',
  'contact'
]
keywords_fr = [
  'accueil',
  'recherche',
  'livre d\'or',
  'blog',
  'événement',
  'à propos',
  'contact'
]

models_name.each_with_index do |element, index|
  element = element.to_s
  optional_module_id = nil
  optional_module_id = @optional_module_search.id if element == 'Search'
  optional_module_id = @optional_module_guest_book.id if element == 'GuestBook'
  optional_module_id = @optional_module_blog.id if element == 'Blog'
  optional_module_id = @optional_module_event.id if element == 'Event'

  menu_id = @menu_home if element == 'Home'
  menu_id = @menu_search if element == 'Search'
  menu_id = @menu_guest_book if element == 'GuestBook'
  menu_id = @menu_blog if element == 'Blog'
  menu_id = @menu_event if element == 'Event'
  menu_id = @menu_about if element == 'About'
  menu_id = @menu_contact if element == 'Contact'

  category = Category.create!(
    name: element,
    optional: optional_module_id.nil? ? false : true,
    optional_module_id: optional_module_id,
    menu_id: menu_id
  )

  referencement = Referencement.create!(
    attachable_id: category.id,
    attachable_type: 'Category',
    title: title_fr[index],
    description: description_fr[index],
    keywords: keywords_fr[index]
  )

  if @locales.include?(:en)
    Referencement::Translation.create!(
      referencement_id: referencement.id,
      locale: 'en',
      title: title_en[index],
      description: description_en[index],
      keywords: keywords_en[index]
    )
  end

  if element == 'Home'
    @category_home = category

    puts 'Uploading background image for homepage'
    Background.create!(
      attachable_id: category.id,
      attachable_type: 'Category',
      image: File.new("#{Rails.root}/public/system/seeds/backgrounds/background_homepage.jpg")
    )
  end
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
  image: File.new("#{Rails.root}/public/system/seeds/abouts/hosting.jpg"),
  online: true
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
referencement = Referencement.create!(
  attachable_id: blog.id,
  attachable_type: 'Blog',
  title: '',
  description: '',
  keywords: ''
)

if @locales.include?(:en)
  Blog::Translation.create!(
    blog_id: blog.id,
    locale: 'en',
    title: 'First blog article',
    slug: 'first-blog-article',
    content: '<p>This is my first blog article !</p>'
  )

  Referencement::Translation.create!(
    referencement_id: referencement.id,
    locale: 'en',
    title: '',
    description: '',
    keywords: ''
  )
end

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
  commentable_id: blog.id,
  commentable_type: 'Blog',
  user_id: nil
)
Comment.create!(
  username: nil,
  email: nil,
  comment: 'Article très intéressant, merci !',
  lang: 'fr',
  validated: true,
  commentable_id: blog.id,
  commentable_type: 'Blog',
  user_id: administrator.id
)

#
# == Event article
#
puts 'Creating Event article'
event_images = [
  'event-1-1.jpg',
  'event-1-2.jpg',
  'event-1-3.jpg'
]
event = Event.create!(
  title: 'Foire aux saucisses',
  slug: 'foire-aux-saucisses',
  content: '<p>Venez gouter les saucisses de la région !</p>',
  url: nil,
  start_date: 2.weeks.ago.to_s(:db),
  end_date: Time.zone.now + 1.week.to_i,
  online: true
)
referencement = Referencement.create!(
  attachable_id: event.id,
  attachable_type: 'Event',
  title: '',
  description: '',
  keywords: ''
)

if @locales.include?(:en)
  Event::Translation.create!(
    event_id: event.id,
    locale: 'en',
    title: 'Sausage market',
    slug: 'sausage-market',
    content: '<p>Come and taste amazing sausage at the market !</p>'
  )
  Referencement::Translation.create!(
    referencement_id: referencement.id,
    locale: 'en',
    title: '',
    description: '',
    keywords: ''
  )
end

puts 'Creating Event Location'
Location.create!(
  locationable_id: event.id,
  locationable_type: 'Event',
  address: 'Rue des Limaces',
  city: 'Lyon',
  postcode: 69_000,
  geocode_address: 'Rue des Limaces, 69000 - Lyon',
  latitude: 45.764,
  longitude: 4.83566
)

puts 'Creating Event pictures'
event_images.each do |image|
  Picture.create!(
    attachable_id: event.id,
    attachable_type: 'Event',
    image: File.new("#{Rails.root}/public/system/seeds/events/#{image}"),
    online: true
  )
end

#
# == Newsletter
#
puts 'Creating Newsletter'
newsletter = Newsletter.create!(
  title: 'Nouveaux contenus sur le site !',
  content: '<p>Trois nouveaux articles ont été publiés sur le site !</p>',
  sent_at: nil
)

if @locales.include?(:en)
  Newsletter::Translation.create!(
    newsletter_id: newsletter.id,
    locale: 'en',
    title: 'New content in the website !',
    content: '<p>Three new contents have been published on the website</p>'
  )
end

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
# == StringBox
#
puts 'Creating StringBox'
string_box_keys = ['error_404', 'error_422', 'error_500', 'success_contact_form', 'adult_not_validated_popup_content']
string_box_title_fr = ['404', '422', '500', 'Message de contact envoyé avec succès', '', 'Majorité requise !']
string_box_title_en = ['404', '422', '500', 'Contact message sent successfuly', '', '']
string_box_content_fr = [
  "<p>Cette page n'existe pas ou n'existe plus.<br /> Nous vous prions de nous excuser pour la gêne occasionnée.</p>",
  '<p>La page que vous tentez de voir n\'est pas disponible pour l\'instant :(</p>',
  '<p>Ooops, une erreur s\'est produite :( Veuillez réésayer ultérieurement</p>',
  '<p>Votre message a bien été envoyé. Merci :)</p>',
  '<p>Pour pouvoir accéder au site, vous devez avoir plus de 18 ans.</p>'
]
string_box_content_en = [
  '<p>The page you want to access doesn\'t exist :(</p>',
  '<p>The page you want to access is not available now :(</p>',
  '<p>Oops, something bad happend :( Please try again later</p>',
  '<p>Your message has been sent successfuly. Thank you :)',
  '<p>In order to access the website, you must be over 18 years old.</p>'
]
string_box_keys.each_with_index do |element, index|
  string_box = StringBox.create!(
    key: element,
    title: string_box_title_fr[index],
    content: string_box_content_fr[index]
  )

  if @locales.include?(:en)
    StringBox::Translation.create!(
      string_box_id: string_box.id,
      locale: 'en',
      title: string_box_title_en[index],
      content: string_box_content_en[index]
    )
  end
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
# == Slider
#
puts 'Creating Slider'
slider = Slider.create!(
  animate: 'crossfade',
  category_id: @category_home.id
)

puts 'Uploading slides image for slider'
slides_image = [ 'slide-1.png', 'slide-2.png', 'slide-3.jpg' ]

slide_title_fr = ['Paysage', 'Ordinateur', '']
slide_title_en = ['Landscape', 'Computer', '']
slide_description_fr = [
  'Course à pied au coucher du soleil',
  '',
  ''
]
slide_description_en = [
  '',
  '',
  ''
]

slides_image.each_with_index do |element, index|
  slide = Slide.create!(
    attachable_id: slider.id,
    attachable_type: 'Slider',
    image: File.new("#{Rails.root}/public/system/seeds/slides/#{element}"),
    title: slide_title_fr[index],
    description: slide_description_fr[index]
  )

  if @locales.include?(:en)
    Slide::Translation.create!(
      slide_id: slide.id,
      locale: 'en',
      title: slide_title_en[index],
      description: slide_description_en[index]
    )
  end
end

#
# == FriendlyId
#
puts 'Setting Friendly Id'
User.find_each(&:save)
Post.find_each(&:save)
Blog.find_each(&:save)
Event.find_each(&:save)

puts 'Seeds successfuly loaded :)'
