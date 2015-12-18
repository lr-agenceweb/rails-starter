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
@setting_site = Setting.create!(
  name: 'L&R Agence web',
  title: 'Rails starter',
  subtitle: 'Site de Démonstration',
  phone: '+33 (0)1 02 03 04 05',
  email: 'demo@starter.fr',
  logo: File.new("#{Rails.root}/public/system/seeds/logo/logo.png"),
  logo_footer: File.new("#{Rails.root}/public/system/seeds/logo/logo-lr-agenceweb.png")
)

if @locales.include?(:en)
  Setting::Translation.create!(
    setting_id: @setting_site.id,
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
  postcode: '96930',
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
  'Module qui affiche un calendrier',
  'Module qui gère la visualisation de vidéos sur le site',
  'Module qui gère l\'envoie de mails en masse'
]
OptionalModule.list.each_with_index do |element, index|
  optional_module = OptionalModule.create!(
    name: element,
    description: description[index],
    enabled: true
  )

  @optional_module_newsletter = optional_module if element == 'Newsletter'
  @optional_module_adult = optional_module if element == 'Adult'
  @optional_module_search = optional_module if element == 'Search'
  @optional_module_guest_book = optional_module if element == 'GuestBook'
  @optional_module_blog = optional_module if element == 'Blog'
  @optional_module_event = optional_module if element == 'Event'
  @optional_module_mailing = optional_module if element == 'Mailing'
end

#
# == Menu
#
puts 'Creating Menu elements'
models_name = [:Home, :Search, :GuestBook, :Blog, :Event, :About, :Contact, :LegalNotice]
title_en = [
  'Home',
  'Search',
  'GuestBook',
  'Blog',
  'Events',
  'About',
  'Contact',
  'Legal notices'
]
title_fr = [
  'Accueil',
  'Recherche',
  'Livre d\'Or',
  'Blog',
  'Événements',
  'À Propos',
  'Me contacter',
  'Mentions légales'
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

models_name.each_with_index do |element, index|
  element = element.to_s
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
  @menu_event = menu.id if element == 'Event'
  @menu_about = menu.id if element == 'About'
  @menu_contact = menu.id if element == 'Contact'
  @menu_legal_notice = menu.id if element == 'LegalNotice'
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
  'Contact description',
  'Legal notices description'
]
description_fr = [
  'Description pour la page d\'accueil',
  'Description de la page recherche',
  'Description de la page livre d\'or',
  'Description de la page Blog',
  'Description de la page événement',
  'Description de la page à propos',
  'Description de la page contact',
  'Description de la page mentions légales'
]
keywords_en = [
  'home',
  'search',
  'guest book',
  'blog',
  'event',
  'about',
  'contact',
  'legal notices'
]
keywords_fr = [
  'accueil',
  'recherche',
  'livre d\'or',
  'blog',
  'événement',
  'à propos',
  'contact',
  'mentions légales'
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
  menu_id = @menu_legal_notice if element == 'LegalNotice'

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

  @category_home = category if element == 'Home'
  @category_blog = category if element == 'Blog'
  @category_event = category if element == 'Event'
end

puts 'Uploading video background for homepage'
video_background = VideoUpload.create!(
  videoable_id: @category_home.id,
  videoable_type: 'Category',
  video_file: File.new("#{Rails.root}/public/system/seeds/videos/background_homepage.mp4")
)

puts 'Uploading background image for event page'
Background.create!(
  attachable_id: @category_event.id,
  attachable_type: 'Category',
  image: File.new("#{Rails.root}/public/system/seeds/backgrounds/background_event.jpg")
)

#
# == LegalNotice articles
#
puts 'Creating LegalNotice article'
legal_notice_title_fr = [
  'Hébergement du site',
  'Nom de domaine'
]
legal_notice_title_en = [
  'Site hosting',
  'Domain name'
]
legal_notice_slug_fr = [
  'hebergement-du-site',
  'nom-de-domaine'
]
legal_notice_slug_en = [
  'site-hosting',
  'domain-name'
]
legal_notice_content_fr = [
  '<p><strong>Ce site est hébergé par</strong>: <br>  Hébergeur : ONLINE SAS<br>  Adresse web : <a href="https://www.online.net/fr">https://www.online.net</a><br>Téléphone : +33.(0)1.84.13.00.00<br>TVA : FR 35 433115904</p><p><strong>Adresse Postale</strong>: <br>  ONLINE SAS<br>  BP 438 75366<br>  PARIS CEDEX 08</p>',
  '<p><strong>Le nom de domaine provient de</strong> :<br>  Hébergeur : OVH SAS<br>  Adresse web : <a href="https://www.ovh.com">https://www.ovh.com</a><br>  Téléphone: 1007<br>  SAS au capital de 10 059 500 €<br>  RCS Lille Métropole 424 761 419 00045<br>  Code APE 6202A<br>  N° TVA : FR 22 424 761 419</p><p><strong>Siège social</strong> :<br>  2 rue Kellermann<br>  59100 Roubaix<br>  France</p>'
]
legal_notice_content_en = [
  '<p><strong>This website is hosted by</strong>: <br>  Host : ONLINE SAS<br> Website : <a href="https://www.online.net/fr">https://www.online.net</a><br>Phone : +33.(0)1.84.13.00.00<br>TVA : FR 35 433115904<br></p><p><strong>Postal address</strong>: <br>  ONLINE SAS<br>  BP 438 75366<br>  PARIS CEDEX 08</p>',
  '<p><strong>The domain name come from</strong> :<br>  Host : OVH SAS<br>Website : <a href="https://www.ovh.com">https://www.ovh.com</a><br>  Phone: 1007<br>  SAS au capital de 10 059 500 €<br>  RCS Lille Métropole 424 761 419 00045<br>  Code APE 6202A<br>  N° TVA : FR 22 424 761 419</p><p><strong>Head office</strong> :<br>  2 rue Kellermann<br>  59100 Roubaix<br>  France</p>'
]
legal_notice_user_id = [
  super_administrator.id,
  super_administrator.id
]

legal_notice_title_fr.each_with_index do |element, index|
  legal_notice = LegalNotice.create!(
    title: legal_notice_title_fr[index],
    slug: legal_notice_slug_fr[index],
    content: legal_notice_content_fr[index],
    online: true,
    user_id: legal_notice_user_id[index]
  )

  if @locales.include?(:en)
    LegalNotice::Translation.create!(
      post_id: legal_notice.id,
      locale: 'en',
      title: legal_notice_title_en[index],
      slug: legal_notice_slug_en[index],
      content: legal_notice_content_en[index]
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
  title: 'Fonds marins',
  slug: 'fonds-marins',
  content: '<p>Voici ce qu\'il se passe sous l\'eau</p>',
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

puts 'Uploading video background for blog'
video_blog = VideoUpload.create!(
  videoable_id: blog.id,
  videoable_type: 'Blog',
  video_file: File.new("#{Rails.root}/public/system/seeds/videos/bubbles.mp4")
)

puts 'Uploading video subtitles for blog'
video_background = VideoSubtitle.create!(
  subtitleable_id: video_blog.id,
  subtitleable_type: 'VideoUpload',
  subtitle_fr: File.new("#{Rails.root}/public/system/seeds/subtitles/bubbles_fr.srt"),
  subtitle_en: File.new("#{Rails.root}/public/system/seeds/subtitles/bubbles_en.srt")
)

if @locales.include?(:en)
  Blog::Translation.create!(
    blog_id: blog.id,
    locale: 'en',
    title: 'Underwater',
    slug: 'underwater',
    content: '<p>This is what happend underwater</p>'
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
# == Blog Setting
#
puts 'Creating Blog Setting'
BlogSetting.create!(prev_next: true)

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
event_title_fr = [
  'Foire aux saucisses',
  'Silky Cam et Tizy Bertrand au Zénith de Paris'
]
event_title_en = [
  'Sausage market',
  'Silky Cam and Tizy Bertrand in concert'
]
event_slug_fr = [
  'foire-aux-saucisses',
  'silky-cam-tizy-bertrand-zenith-paris'
]
event_slug_en = [
  'sausage-market',
  'silky-cam-tizy-bertrand-concert'
]
event_content_fr = [
  '<p>Venez gouter les saucisses de la région !</p>',
  '<p>Venez assister au concert exceptionnel de Silky Cam et Tizy Bertrand au Zénith de Paris !</p>'
]
event_content_en = [
  '<p>Come and taste amazing sausage at the market !</p>',
  '<p>Come to assist to the concert of Silky Cam and Tizy Bertrand !</p>'
]

event_start_date = [2.weeks.ago.to_s(:db), 2.weeks.ago.to_s(:db)]
event_end_date = [Time.zone.now + 1.week.to_i, Time.zone.now + 3.week.to_i]
event_url = [nil, nil]

event_address = ['Rue des Limaces', 'Zénith de Paris, 205 Bd Sérurier']
event_city = ['Lyon', 'Paris']
event_postcode = [69_000, 75_019]
event_geocode = ['Rue des Limaces, 69000 - Lyon', 'Zénith de Paris, 205 Bd Sérurier, 75019 - Paris']
event_latitude = [45.764, 43.5947418]
event_longitude = [4.83566, 1.409389]

event_images = [
  ['event-1-1.jpg', 'event-1-2.jpg', 'event-1-3.jpg'],
  [nil]
]
event_videos = [nil, 'http://www.dailymotion.com/video/x38cajc']

event_title_fr.each_with_index do |element, index|
  event = Event.create!(
    title: event_title_fr[index],
    slug: event_slug_fr[index],
    content: event_content_fr[index],
    url: event_url[index],
    start_date: event_start_date[index],
    end_date: event_end_date[index],
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
      title: event_title_en[index],
      slug: event_slug_en[index],
      content: event_content_en[index]
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
    address: event_address[index],
    city: event_city[index],
    postcode: event_postcode[index],
    geocode_address: event_geocode[index],
    latitude: event_latitude[index],
    longitude: event_longitude[index]
  )


  event_images[index].each_with_index do |image, index|
    unless image.nil?
      puts 'Creating Event pictures'
      Picture.create!(
        attachable_id: event.id,
        attachable_type: 'Event',
        image: File.new("#{Rails.root}/public/system/seeds/events/#{image}"),
        online: true
      )
    end
  end

  unless event_videos[index].nil?
    puts 'Creating Event VideoPlatform'
    VideoPlatform.create!(
      videoable_id: event.id,
      videoable_type: 'Event',
      url: event_videos[index],
      native_informations: true,
      online: true
    )
  end
end


#
# == Event Order
#
puts 'Creating Event Order'
event_order_key = ['current_or_coming', 'all']
event_order_name = ['Courant et à venir (avec le plus récent en premier)', 'Tous (même ceux qui sont déjà passés)']
event_order_name.each_with_index do |order, index|
  eo = EventOrder.create!(key: event_order_key[index], name: order)
  @event_order = eo if index == 0
end

#
# == Event Setting
#
puts 'Creating Event Setting'
EventSetting.create!(prev_next: true, event_order_id: @event_order.id)

#
# == Newsletter Setting
#
puts 'Creating Newsletter Setting'
@newsletter_setting = NewsletterSetting.create!(
  send_welcome_email: true,
  title_subscriber: 'Bienvenue à la newsletter',
  content_subscriber: '<p>Vous êtes maintenant abonné à la newsletter, vous la recevrez environ une fois par mois. Votre email ne sera pas utilisé pour vous spammer.</p>'
)
if @locales.include?(:en)
  NewsletterSetting::Translation.create!(
    newsletter_setting_id: @newsletter_setting.id,
    locale: 'en',
    title_subscriber: 'Welcome to the newsletter',
    content_subscriber: '<p>You are now subscribed to the newsletter, you will receive it once a month. Your email will not be use for spam.</p>'
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
# == Newsletter User Roles
#
puts 'Creating Newsletter User Roles'
newsletter_user_role_title_fr = [
  'abonné',
  'testeur'
]
newsletter_user_role_title_en = [
  'subscriber',
  'tester'
]

newsletter_user_role_title_en.each_with_index do |element, index|
  newsletter_user_role = NewsletterUserRole.create!(
    rollable_id: @newsletter_setting.id,
    rollable_type: 'NewsletterSetting',
    title: newsletter_user_role_title_fr[index],
    kind: newsletter_user_role_title_en[index]
  )

  if @locales.include?(:en)
    NewsletterUserRole::Translation.create!(
      newsletter_user_role_id: newsletter_user_role.id,
      locale: 'en',
      title: newsletter_user_role_title_en[index]
    )
  end

  @newsletter_user_role_subscriber = newsletter_user_role if element == 'subscriber'
  @newsletter_user_role_tester = newsletter_user_role if element == 'tester'
end

#
# == Newsletter User
#
puts 'Creating Newsletter User'
NewsletterUser.create!(
  email: 'abonne@test.fr',
  lang: 'fr',
  token: 'df6dbd90f13d7c8',
  newsletter_user_role_id: @newsletter_user_role_subscriber.id
)
NewsletterUser.create!(
  email: 'subscriber@test.en',
  lang: 'en',
  token: '5f9a50a21As109Qw',
  newsletter_user_role_id: @newsletter_user_role_subscriber.id
)

#
# == AdultSetting
#
puts 'Creating AdultSetting'
adult_setting = AdultSetting.create!(
  enabled: true,
  title: 'Bienvenue sur le site de démonstration des modules !',
  content: "<p>Vous allez pouvoir les tester et également les gérer depuis le panneau d'administration.</p> <p>Ce popup est un aperçu du module \"<strong>Adulte</strong>\" (majorité requise pour certains sites comme les vignerons)</p> <p><strong>Cliquez oui si vous avez plus de 18 ans pour continuer ;)</strong></p>",
  redirect_link: Figaro.env.adult_not_validated_popup_redirect_link
)

if @locales.include?(:en)
  AdultSetting::Translation.create!(
    adult_setting_id: adult_setting.id,
    locale: 'en',
    title: 'Welcome to the demonstration website for modules',
    content: "<p>In order to access the website, you must be over 18 years old.</p><p>More content soon</p>"
  )
end

#
# == StringBox
#
puts 'Creating StringBox'
string_box_keys = [
  'error_404',
  'error_422',
  'error_500',
  'success_contact_form'
]
string_box_descriptions = [
  'Message à afficher en cas d\'erreur 404 (page introuvable)',
  'Message à afficher en cas d\'erreur 422 (page indisponible ponctuellement)',
  'Message à afficher en cas d\'erreur 500 (erreur du serveur)',
  'Message de succès à afficher lorsque le formulaire de contact a bien envoyé le mail à l\'administrateur'
]
string_box_title_fr = [
  '404',
  '422',
  '500',
  'Message de contact envoyé avec succès'
]
string_box_title_en = [
  '404',
  '422',
  '500',
  'Contact message sent successfuly'
]
string_box_content_fr = [
  "<p>Cette page n'existe pas ou n'existe plus.<br /> Nous vous prions de nous excuser pour la gêne occasionnée.</p>",
  '<p>La page que vous tentez de voir n\'est pas disponible pour l\'instant :(</p>',
  '<p>Ooops, une erreur s\'est produite :( Veuillez réésayer ultérieurement</p>',
  '<p>Votre message a bien été envoyé. Merci :)</p>'
]
string_box_content_en = [
  '<p>The page you want to access doesn\'t exist :(</p>',
  '<p>The page you want to access is not available now :(</p>',
  '<p>Oops, something bad happend :( Please try again later</p>',
  '<p>Your message has been sent successfuly. Thank you :)'
]
optional_module_id = [
  nil,
  nil,
  nil,
  nil
]

string_box_keys.each_with_index do |element, index|
  string_box = StringBox.create!(
    key: element,
    description: string_box_descriptions[index],
    title: string_box_title_fr[index],
    content: string_box_content_fr[index],
    optional_module_id: optional_module_id[index]
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
  navigation: true,
  category_id: @category_blog.id
)

puts 'Uploading slides image for slider'
slides_image = ['slide-1.jpg', 'slide-2.png', 'slide-3.jpg', 'slide-4.jpg']

slide_title_fr = ['Paysage', 'Ordinateur', 'Evénement Sportif']
slide_title_en = ['Landscape', 'Computer', 'Sport Event']
slide_description_fr = [
  'Paysage de montagne',
  '',
  '',
  ''
]
slide_description_en = [
  '',
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
# == Social
#
social_share_title = ['Facebook', 'Twitter', 'Google+', 'Email']
social_share_ikon = ['facebook', 'twitter', 'google', 'envelope']

social_share_title.each_with_index do |element, index|
  puts "Create Socials share #{element}"
  Social.create!(
    kind: 'share',
    title: social_share_title[index],
    font_ikon: social_share_ikon[index]
  )
end

#
# == VideoSetting
#
puts 'Create video settings'
VideoSetting.create!(
  video_platform: true,
  video_upload: true,
  video_background: true
)

#
# == MailingSetting
#
puts 'Create mailing settings'
mailing_setting = MailingSetting.create!(
  name: nil,
  email: nil,
  signature: @setting_site.name,
  unsubscribe_title: ':(',
  unsubscribe_content: "<p>Votre email a bien été retiré de notre liste. Vous ne recevrez plus de mails de #{@setting_site.title}.</p>"
)
if @locales.include?(:en)
  MailingSetting::Translation.create!(
    mailing_setting_id: mailing_setting.id,
    locale: 'en',
    signature: @setting_site.name,
    unsubscribe_title: ':(',
    unsubscribe_content: "<p>Your email has been removed from our mailing list. You will no longer receive email from #{@setting_site.title}.</p>"
  )
end

#
# == MailingUser
#
puts 'Creating users for mailing'
10.times do
  MailingUser.create(
    fullname: Faker::Name.name,
    email: Faker::Internet.email,
    lang: @locales.include?(:en) ? ['fr', 'en'].sample : 'fr',
    archive: [true, false].sample
  )
end

#
# == MailingMessage
#
puts 'Creating email message'
mailing_message = MailingMessage.create!(
  title: "Titre de l'email en Français",
  content: "Contenu du mailing en Français"
)
if @locales.include?(:en)
  MailingMessage::Translation.create!(
    mailing_message_id: mailing_message.id,
    locale: 'en',
    title: 'Title email in english',
    content: 'English mailing content'
  )
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
