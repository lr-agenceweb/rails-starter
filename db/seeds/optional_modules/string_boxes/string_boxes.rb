# frozen_string_literal: true

#
# == StringBox
#
puts 'Creating StringBox'
string_box_keys = %w(error_404 error_422 error_500 success_contact_form, answering_machine)
string_box_descriptions = [
  'Message à afficher en cas d\'erreur 404 (page introuvable)',
  'Message à afficher en cas d\'erreur 422 (page indisponible ponctuellement)',
  'Message à afficher en cas d\'erreur 500 (erreur du serveur)',
  'Message de succès à afficher lorsque le formulaire de contact a bien envoyé le mail à l\'administrateur',
  'Message automatique envoyé aux internautes lorsqu\'il essaye de vous contacter'
]
string_box_title_fr = [
  '404',
  '422',
  '500',
  'Message de contact envoyé avec succès',
  'Répondeur de contact automatique'
]
string_box_title_en = [
  '404',
  '422',
  '500',
  'Contact message sent successfuly',
  'Automatic contact form answering machine'
]
string_box_content_fr = [
  "<p>Cette page n'existe pas ou n'existe plus.<br /> Nous vous prions de nous excuser pour la gêne occasionnée.</p>",
  '<p>La page que vous tentez de voir n\'est pas disponible pour l\'instant :(</p>',
  '<p>Ooops, une erreur s\'est produite :( Veuillez réésayer ultérieurement</p>',
  '<p>Votre message a bien été envoyé. Merci :)</p>',
  '<p>Nous sommes actuellement en vacances, nous vous répondrons lors de notre retour.<br /><br />Merci de votre confiance !</p>'
]
string_box_content_en = [
  '<p>The page you want to access doesn\'t exist :(</p>',
  '<p>The page you want to access is not available now :(</p>',
  '<p>Oops, something bad happend :( Please try again later</p>',
  '<p>Your message has been sent successfuly. Thank you :)',
  '<p> We are in currently in holidays. We will answer you when we return.<br /><br />Thanks for your trust !</p>'
]
optional_module_id = [
  nil,
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
