# frozen_string_literal: true

#
# == Newsletter Setting
#
puts 'Creating Newsletter Setting'
@newsletter_setting = NewsletterSetting.create!(
  send_welcome_email: true,
  title_subscriber: 'Bienvenue à la newsletter',
  content_subscriber: '<p>Vous êtes maintenant abonné à la newsletter, vous la recevrez environ une fois par mois. Votre email ne sera pas utilisé pour vous spammer.</p>'
)
if @locales.include?(:en)
  NewsletterSetting::Translation.create!(
    newsletter_setting_id: @newsletter_setting.id,
    locale: 'en',
    title_subscriber: 'Welcome to the newsletter',
    content_subscriber: '<p>You are now subscribed to the newsletter, you will receive it once a month. Your email will not be use for spam.</p>'
  )
end
