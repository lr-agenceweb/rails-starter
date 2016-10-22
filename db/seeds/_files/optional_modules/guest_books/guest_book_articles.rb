# frozen_string_literal: true

#
# == GuestBook
#
puts 'Creating GuestBook'
15.times do
  g = GuestBook.create!(
    username: Faker::Name.name,
    email: Faker::Internet.email,
    content: Faker::Lorem.paragraph(3, true),
    lang: I18n.available_locales.sample,
  )
  g.update_attribute(:validated, true)
end
