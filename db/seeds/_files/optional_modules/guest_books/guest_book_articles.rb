# frozen_string_literal: true

#
# == GuestBook
#
puts 'Creating GuestBook'
15.times do
  GuestBook.create(
    username: Faker::Name.name,
    email: Faker::Internet.email,
    content: Faker::Lorem.paragraph(3, true),
    lang: @locales.include?(:en) ? %w(fr en).sample : 'fr',
    validated: true
  )
end
