# frozen_string_literal: true

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
