# frozen_string_literal: true

#
# == Settings for site
#
puts 'Creating site Setting'
@setting_site = Setting.create!(
  name: 'L&R Agence web',
  title: 'Rails starter',
  subtitle: 'Site de Démonstration',
  phone: '+33 (0)1 02 03 04 05',
  email: 'demo@starter.fr',
  logo: File.new("#{Rails.root}/db/seeds/logo/logo.png"),
  logo_footer: File.new("#{Rails.root}/db/seeds/logo/logo-lr-agenceweb.png"),
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
