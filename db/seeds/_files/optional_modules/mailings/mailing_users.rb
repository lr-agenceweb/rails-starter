# frozen_string_literal: true

#
# == MailingUser
#
puts 'Creating users for mailing'
10.times do
  MailingUser.create(
    fullname: Faker::Name.name,
    email: Faker::Internet.email,
    lang: @locales.include?(:en) ? %w(fr en).sample : 'fr',
    archive: [true, false].sample
  )
end
