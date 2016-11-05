# frozen_string_literal: true

#
# == Newsletter User
#
puts 'Creating NewsletterUser'
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
