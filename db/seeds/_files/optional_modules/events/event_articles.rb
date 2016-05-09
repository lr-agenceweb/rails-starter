# frozen_string_literal: true

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
event_end_date = [Time.zone.now + 1.week.to_i, Time.zone.now + 3.weeks.to_i]
event_url = ['http://google.com', nil]

event_address = ['Rue des Limaces', 'Zénith de Paris, 205 Bd Sérurier']
event_city = %w(Lyon Paris)
event_postcode = [69_000, 75_019]
event_geocode = ['Rue des Limaces, 69000 - Lyon', 'Zénith de Paris, 205 Bd Sérurier, 75019 - Paris']
event_latitude = [45.764, 43.5947418]
event_longitude = [4.83566, 1.409389]

event_images = [
  ['event-1-1.jpg', 'event-1-2.jpg', 'event-1-3.jpg'],
  [nil]
]
event_videos = [nil, 'http://www.dailymotion.com/video/x38cajc']

event_title_fr.each_with_index do |_element, index|
  event = Event.create!(
    title: event_title_fr[index],
    slug: event_slug_fr[index],
    content: event_content_fr[index],
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

  puts 'Creating Event Link'
  Link.create!(
    linkable_id: event.id,
    linkable_type: 'Event',
    url: event_url[index]
  )

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

  event_images[index].each_with_index do |image, _|
    next if image.nil?
    puts 'Creating Event pictures'
    Picture.create!(
      attachable_id: event.id,
      attachable_type: 'Event',
      image: File.new("#{Rails.root}/db/seeds/events/#{image}"),
      online: true
    )
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
