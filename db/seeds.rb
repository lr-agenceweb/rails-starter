#
# == Variables
#
ahora = Time.zone.now

#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
modeles_str = %w(User)
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