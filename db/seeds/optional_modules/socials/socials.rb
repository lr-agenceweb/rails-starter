# frozen_string_literal: true

#
# == Social
#
puts 'Create Social'

social_share_title = ['Facebook', 'Twitter', 'Google+', 'Email']
social_share_ikon = %w(facebook twitter google envelope)

social_share_title.each_with_index do |element, index|
  puts "Create Socials share #{element}"
  Social.create!(
    kind: 'share',
    title: social_share_title[index],
    font_ikon: social_share_ikon[index]
  )
end
