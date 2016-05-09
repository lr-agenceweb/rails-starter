# frozen_string_literal: true

#
# == Location
#
puts 'Creating Location for Setting'
Location.create!(
  locationable_id: @setting_site.id,
  locationable_type: 'Setting',
  address: 'Place du Père Noël',
  city: 'Rovaniemi',
  postcode: '96930',
  geocode_address: 'Père Noël, 96930 Rovaniemi, Finlande',
  latitude: 66.5435,
  longitude: 25.8481
)
