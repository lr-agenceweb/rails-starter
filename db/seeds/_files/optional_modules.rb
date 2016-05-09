# frozen_string_literal: true

#
# == OptionalModules
#
puts 'Creating OptionalModules'
description = [
  'Module qui affiche un formulaire pour s\abonner à la newsletter et authorise l\'administrateur à envoyer des mails aux abonnés',
  'Module livre d\'or dans lequel les internautes pourront laisser leur avis',
  'Module de recherche sur le site',
  'Module RSS, donne la possibilité aux internautes de s\'abonner aux articles Post et Blog du site',
  'Module de commentaire: permet aux internautes de commenter les articles Post ou de Blog',
  'Module Blog où l\'administrateur peut créer des articles',
  'Module qui affiche une popup demandant aux internet d\'attester qu\'ils sont bien majeurs pour continuer à visiter le site',
  'Module qui affiche slider avec des images défilantes',
  'Module qui gère des événements à venir',
  'Module qui affiche une carte Mapbox sur le site',
  'Module qui gère les différents réseaux sociaux',
  'Module qui affiche un fil d\'ariane sur le site',
  'Module qui affiche un Qrcode pour créer automatiquement un contact sur son smartphone',
  'Module qui propose à l\'administrateur de choisir une image d\'arrière plan pour les pages du site',
  'Module qui affiche un calendrier',
  'Module qui gère la visualisation de vidéos sur le site',
  'Module qui gère l\'envoie de mails en masse',
  'Module qui gère la connexion par réseaux sociaux',
  'Module qui autorise l\'upload de fichiers audios'
]
OptionalModule.list.each_with_index do |element, index|
  optional_module = OptionalModule.create!(
    name: element,
    description: description[index],
    enabled: true
  )

  instance_variable_set("@optional_module_#{element.to_s.underscore}", optional_module)
end
