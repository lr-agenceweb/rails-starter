# frozen_string_literal: true

#
# == AdultSetting
#
puts 'Creating AdultSetting'
adult_setting = AdultSetting.create!(
  enabled: true,
  title: 'Bienvenue sur le site de démonstration des modules !',
  content: "<p>Vous allez pouvoir les tester et également les gérer depuis le panneau d'administration.</p> <p>Ce popup est un aperçu du module \"<strong>Adulte</strong>\" (majorité requise pour certains sites comme les vignerons)</p> <p><strong>Cliquez oui si vous avez plus de 18 ans pour continuer ;)</strong></p>",
  redirect_link: Figaro.env.adult_not_validated_popup_redirect_link
)

if @locales.include?(:en)
  AdultSetting::Translation.create!(
    adult_setting_id: adult_setting.id,
    locale: 'en',
    title: 'Welcome to the demonstration website for modules',
    content: "<p>In order to access the website, you must be over 18 years old.</p><p>More content soon</p>"
  )
end
