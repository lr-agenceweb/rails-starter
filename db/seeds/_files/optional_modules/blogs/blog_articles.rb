# frozen_string_literal: true

#
# == Blog article
#
puts 'Creating Blog article'
@blog = Blog.create!(
  title: 'Fonds marins',
  slug: 'fonds-marins',
  content: '<p>Voici ce qu\'il se passe sous l\'eau</p>',
  online: true,
  blog_category_id: @blog_category.id,
  user_id: @administrator.id
)
referencement = Referencement.create!(
  attachable_id: @blog.id,
  attachable_type: 'Blog',
  title: '',
  description: '',
  keywords: ''
)

puts 'Uploading video background for blog'
video_blog = VideoUpload.create!(
  videoable_id: @blog.id,
  videoable_type: 'Blog',
  video_file: File.new("#{Rails.root}/db/seeds/videos/bubbles.mp4")
)

puts 'Uploading video subtitles for blog'
VideoSubtitle.create!(
  subtitleable_id: video_blog.id,
  subtitleable_type: 'VideoUpload',
  subtitle_fr: File.new("#{Rails.root}/db/seeds/subtitles/bubbles_fr.srt"),
  subtitle_en: File.new("#{Rails.root}/db/seeds/subtitles/bubbles_en.srt")
)

if @locales.include?(:en)
  Blog::Translation.create!(
    blog_id: @blog.id,
    locale: 'en',
    title: 'Underwater',
    slug: 'underwater',
    content: '<p>This is what happend underwater</p>'
  )

  Referencement::Translation.create!(
    referencement_id: referencement.id,
    locale: 'en',
    title: '',
    description: '',
    keywords: ''
  )
end
