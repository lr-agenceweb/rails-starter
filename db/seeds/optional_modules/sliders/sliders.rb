# frozen_string_literal: true

#
# == Slider
#
puts 'Creating Slider'
slider = Slider.create!(
  animate: 'crossfade',
  navigation: true,
  page_id: @page_blog.id
)

puts 'Uploading slides image for slider'
4.times do |i|
  boolean = [true, false].sample
  download = open('https://unsplash.it/1920/900/?random')
  file_path = "#{@tmp_path}/image.jpg"
  IO.copy_stream(download, file_path)

  slide = Slide.create!(
    attachable_id: slider.id,
    attachable_type: 'Slider',
    image: File.new(file_path),
    title: boolean ? Faker::Hipster.sentence(3) : nil,
    description: boolean ? Faker::Hipster.sentence : nil
  )

  if @locales.include?(:en)
    Slide::Translation.create!(
      slide_id: slide.id,
      locale: 'en',
      title: boolean ? Faker::Hipster.sentence(3) : nil,
      description: boolean ? Faker::Hipster.sentence : nil
    )
  end
end
