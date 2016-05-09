# frozen_string_literal: true

#
# == Menu
#
puts 'Creating Menu elements'
@models_name = [:Home, :Search, :GuestBook, :Blog, :Event, :About, :Contact, :LegalNotice, :Connection]
@title_en = [
  'Home',
  'Search',
  'GuestBook',
  'Blog',
  'Events',
  'About',
  'Contact',
  'Legal notices',
  'Links'
]
@title_fr = [
  'Accueil',
  'Recherche',
  'Livre d\'Or',
  'Blog',
  'Événements',
  'À Propos',
  'Me contacter',
  'Mentions légales',
  'Liens'
]
show_in_header = [
  true,
  false,
  true,
  true,
  true,
  false,
  true,
  false,
  true
]
show_in_footer = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
]

@models_name.each_with_index do |element, index|
  element = element.to_s
  menu = Menu.create!(
    title: @title_fr[index],
    show_in_header: show_in_header[index],
    show_in_footer: show_in_footer[index],
    online: true
  )
  if @locales.include?(:en)
    Menu::Translation.create!(
      menu_id: menu.id,
      locale: 'en',
      title: @title_en[index]
    )
  end

  instance_variable_set("@menu_#{element.to_s.underscore}", menu)
end
