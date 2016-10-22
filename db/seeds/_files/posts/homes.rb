# frozen_string_literal: true

#
# == Home article
#
puts 'Creating Home article'
home = Home.new(
  title: set_title,
  content: set_content,
  online: true,
  user_id: @administrator.id
)
home.save(validate: false)

if @locales.include?(:en)
  Home::Translation.create!(
    post_id: home.id,
    locale: 'en',
    title: set_title,
    content: set_content
  )
end

# Referencement
set_referencement(home, 'Post')
