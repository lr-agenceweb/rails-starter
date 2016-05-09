# frozen_string_literal: true

#
# == MailingMessage
#
puts 'Creating email message'
mailing_message = MailingMessage.create!(
  title: "Titre de l'email en Français",
  content: "Contenu du mailing en Français"
)
if @locales.include?(:en)
  MailingMessage::Translation.create!(
    mailing_message_id: mailing_message.id,
    locale: 'en',
    title: 'Title email in english',
    content: 'English mailing content'
  )
end
