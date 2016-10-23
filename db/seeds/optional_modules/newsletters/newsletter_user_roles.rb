# frozen_string_literal: true

#
# == Newsletter User Roles
#
puts 'Creating NewsletterUserRole'
newsletter_user_role_title_fr = %w(abonné testeur)
newsletter_user_role_title_en = %w(subscriber tester)

newsletter_user_role_title_en.each_with_index do |element, index|
  newsletter_user_role = NewsletterUserRole.create!(
    rollable_id: @newsletter_setting.id,
    rollable_type: 'NewsletterSetting',
    title: newsletter_user_role_title_fr[index],
    kind: newsletter_user_role_title_en[index]
  )

  if @locales.include?(:en)
    NewsletterUserRole::Translation.create!(
      newsletter_user_role_id: newsletter_user_role.id,
      locale: 'en',
      title: newsletter_user_role_title_en[index]
    )
  end

  @newsletter_user_role_subscriber = newsletter_user_role if element == 'subscriber'
  @newsletter_user_role_tester = newsletter_user_role if element == 'tester'
end
