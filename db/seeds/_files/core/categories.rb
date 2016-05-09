# frozen_string_literal: true

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
  'Legal notices description',
  'Link description'
]
description_fr = [
  'Description pour la page d\'accueil',
  'Description de la page recherche',
  'Description de la page livre d\'or',
  'Description de la page Blog',
  'Description de la page événement',
  'Description de la page à propos',
  'Description de la page contact',
  'Description de la page mentions légales',
  'Description de la page liens'
]
keywords_en = [
  'home',
  'search',
  'guest book',
  'blog',
  'event',
  'about',
  'contact',
  'legal notices',
  'links'
]
keywords_fr = [
  'accueil',
  'recherche',
  'livre d\'or',
  'blog',
  'événement',
  'à propos',
  'contact',
  'mentions légales',
  'liens'
]

@models_name.each_with_index do |element, index|
  element = element.to_s
  optional_module = instance_variable_get("@optional_module_#{element.to_s.underscore}")

  category = Category.create!(
    name: element,
    optional: optional_module.nil? ? false : true,
    optional_module_id: optional_module.try(:id),
    menu_id: instance_variable_get("@menu_#{element.underscore}").id
  )

  referencement = Referencement.create!(
    attachable_id: category.id,
    attachable_type: 'Category',
    title: @title_fr[index],
    description: description_fr[index],
    keywords: keywords_fr[index]
  )

  if @locales.include?(:en)
    Referencement::Translation.create!(
      referencement_id: referencement.id,
      locale: 'en',
      title: @title_en[index],
      description: description_en[index],
      keywords: keywords_en[index]
    )
  end

  instance_variable_set("@category_#{element.to_s.underscore}", category)
end

puts 'Uploading video background for homepage'
video_background = VideoUpload.create!(
  videoable_id: @category_home.id,
  videoable_type: 'Category',
  video_file: File.new("#{Rails.root}/db/seeds/videos/background_homepage.mp4")
)

puts 'Uploading background image for event page'
Background.create!(
  attachable_id: @category_event.id,
  attachable_type: 'Category',
  image: File.new("#{Rails.root}/db/seeds/backgrounds/background_event.jpg")
)
