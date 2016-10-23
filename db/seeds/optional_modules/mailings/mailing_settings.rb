# frozen_string_literal: true

#
# == MailingSetting
#
puts 'Creating MailingSetting'
mailing_setting = MailingSetting.create!(
  name: nil,
  email: nil,
  signature: @setting_site.name,
  unsubscribe_title: ':(',
  unsubscribe_content: "<p>Votre email a bien été retiré de notre liste. Vous ne recevrez plus de mails de #{@setting_site.title}.</p>"
)
if @locales.include?(:en)
  MailingSetting::Translation.create!(
    mailing_setting_id: mailing_setting.id,
    locale: 'en',
    signature: @setting_site.name,
    unsubscribe_title: ':(',
    unsubscribe_content: "<p>Your email has been removed from our mailing list. You will no longer receive email from #{@setting_site.title}.</p>"
  )
end
