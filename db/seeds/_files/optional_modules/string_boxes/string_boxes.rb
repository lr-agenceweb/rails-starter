# frozen_string_literal: true

#
# == StringBox
#
puts 'Creating StringBox'
string_box_keys = %w(error_404 error_422 error_500 success_contact_form)
string_box_descriptions = [
  'Message à afficher en cas d\'erreur 404 (page introuvable)',
  'Message à afficher en cas d\'erreur 422 (page indisponible ponctuellement)',
  'Message à afficher en cas d\'erreur 500 (erreur du serveur)',
  'Message de succès à afficher lorsque le formulaire de contact a bien envoyé le mail à l\'administrateur'
]
string_box_title_fr = [
  '404',
  '422',
  '500',
  'Message de contact envoyé avec succès'
]
string_box_title_en = [
  '404',
  '422',
  '500',
  'Contact message sent successfuly'
]
string_box_content_fr = [
  "<p>Cette page n'existe pas ou n'existe plus.<br /> Nous vous prions de nous excuser pour la gêne occasionnée.</p>",
  '<p>La page que vous tentez de voir n\'est pas disponible pour l\'instant :(</p>',
  '<p>Ooops, une erreur s\'est produite :( Veuillez réésayer ultérieurement</p>',
  '<p>Votre message a bien été envoyé. Merci :)</p>'
]
string_box_content_en = [
  '<p>The page you want to access doesn\'t exist :(</p>',
  '<p>The page you want to access is not available now :(</p>',
  '<p>Oops, something bad happend :( Please try again later</p>',
  '<p>Your message has been sent successfuly. Thank you :)'
]
optional_module_id = [
  nil,
  nil,
  nil,
  nil
]

string_box_keys.each_with_index do |element, index|
  string_box = StringBox.create!(
    key: element,
    description: string_box_descriptions[index],
    title: string_box_title_fr[index],
    content: string_box_content_fr[index],
    optional_module_id: optional_module_id[index]
  )

  if @locales.include?(:en)
    StringBox::Translation.create!(
      string_box_id: string_box.id,
      locale: 'en',
      title: string_box_title_en[index],
      content: string_box_content_en[index]
    )
  end
end
