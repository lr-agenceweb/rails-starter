# frozen_string_literal: true

#
# == About article
#
puts 'Creating About article'
3.times do |i|
  about = About.new(
    title: set_title,
    content: set_content,
    show_as_gallery: true,
    online: true,
    user_id: @administrator.id
  )
  about.save(validate: false)

  if @locales.include?(:en)
    About::Translation.create!(
      post_id: about.id,
      locale: 'en',
      title: set_title,
      content: set_content
    )
  end

  # Picture
  set_picture(about, 'Post')

  # Referencement
  set_referencement(about, 'Post')
end
