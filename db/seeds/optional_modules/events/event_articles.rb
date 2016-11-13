# frozen_string_literal: true

#
# == Event article
#
puts 'Creating Event articles'
10.times do |i|
  event = Event.new(
    title: set_title,
    content: set_content,
    show_as_gallery: true,
    show_map: true,
    show_calendar: true,
    online: true,
    start_date: Faker::Time.between(10.days.ago, DateTime.now + 10.days, :afternoon),
    end_date: Faker::Time.between(DateTime.now + 10.days, DateTime.now + 30.days, :afternoon)
  )
  event.save(validate: false)

  if @locales.include?(:en)
    Event::Translation.create!(
      event_id: event.id,
      locale: 'en',
      title: set_title,
      content: set_content
    )
  end

  # Pictures
  [*1..6].sample.times { set_picture(event, 'Event') }

  # Referencement
  set_referencement(event, 'Event')

  # Link
  Link.create!(
    linkable_id: event.id,
    linkable_type: 'Event',
    url: Faker::Internet.url
  )

  # Location
  set_location(event, 'Event')

  # VideoPlatform
  if i.zero?
    VideoPlatform.create!(
      videoable_id: event.id,
      videoable_type: 'Event',
      url: 'https://www.youtube.com/watch?v=ScMzIvxBSi4',
      native_informations: true,
      online: true
    )
  end
end
