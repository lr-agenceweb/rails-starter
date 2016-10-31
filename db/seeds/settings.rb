# frozen_string_literal: true

#
# == Settings for site
#
puts 'Creating site Setting'
@setting_site = Setting.create!(
  title: 'Rails starter',
  subtitle: 'Site de Démonstration',
  name: Faker::Name.name,
  phone: Faker::PhoneNumber.cell_phone,
  email: Faker::Internet.safe_email,
  logo: File.new("#{Rails.root}/db/seeds/fixtures/logo/logo.png"),
  logo_footer: File.new("#{Rails.root}/db/seeds/fixtures/logo/logo-lr-agenceweb.png"),
  per_page: 5,
  show_map: true,
  show_qrcode: true,
  show_breadcrumb: true,
  show_file_upload: true,
  answering_machine: true
)

if @locales.include?(:en)
  Setting::Translation.create!(
    setting_id: @setting_site.id,
    locale: 'en',
    title: 'Rails starter',
    subtitle: 'Demo website'
  )
end
