#
# == Variables
#
ahora = Time.zone.now

#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
modeles_str = %w(User Setting Setting::Translation)
modeles_str.each do |modele_str|
  modele = modele_str.constantize
  modele.destroy_all
  ActiveRecord::Base.connection.execute("ALTER TABLE #{modele.table_name} AUTO_INCREMENT = 1")
end

#
# == Create a default user
#
puts 'Creating users'
User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
)
User.create!(
  email: 'admin2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

#
# == Settings for site
#
puts 'Creating site Setting'
setting_site = Setting.create!(
  name: 'Rails startup',
  title: 'Demo site',
  subtitle: 'démarre rapidement',
  phone: '01 02 03 04 05',
  email: 'demo@startup.fr',
  address: 'Rude la biche',
  city: 'Paris',
  postcode: 75_000,
  geocode_address: '',
  latitude: nil,
  longitude: nil,
  show_map: false,
  created_at: ahora,
  updated_at: nil
)

Setting::Translation.create!(
  setting_id: setting_site.id,
  locale: 'en',
  title: 'Demo site',
  subtitle: 'start quickly',
  created_at: ahora,
  updated_at: nil
)
