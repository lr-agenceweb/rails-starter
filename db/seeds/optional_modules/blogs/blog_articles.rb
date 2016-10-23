# frozen_string_literal: true

#
# == Blog article
#
puts 'Creating Blog articles'
10.times do |i|
  blog = Blog.new(
    title: set_title,
    content: set_content,
    online: true,
    blog_category_id: BlogCategory.all.map(&:id).sample,
    user_id: @administrator.id
  )
  blog.save(validate: false)

  if @locales.include?(:en)
    Blog::Translation.create!(
      blog_id: blog.id,
      locale: 'en',
      title: set_title,
      content: set_content
    )
  end

  # Picture
  set_picture(blog, 'Blog')

  # Referencement
  set_referencement(blog, 'Blog')

  # PublicationDate
  publication_date = PublicationDate.create!(
    publishable_id: blog.id,
    publishable_type: 'Blog'
  )

  # VideoUpload
  if i == 9
    # Audio
    set_audio(blog, 'Blog', 'http://www.worldnationalanthem.com/wp-content/uploads/2015/05/National-Anthem-Of-France.mp3')

    # VideoUpload
    vu = set_video_upload(blog, 'Blog', 'http://www.w3schools.com/html/mov_bbb.mp4')

    VideoSubtitle.create!(
      subtitleable_id: vu.id,
      subtitleable_type: 'VideoUpload',
      subtitle_fr: File.new("#{Rails.root}/db/seeds/fixtures/subtitles/big_buck_bunny.fr.srt"),
      subtitle_en: File.new("#{Rails.root}/db/seeds/fixtures/subtitles/big_buck_bunny.en.srt")
    )
  end
end
