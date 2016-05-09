# frozen_string_literal: true

#
# == Slider
#
puts 'Creating Slider'
slider = Slider.create!(
  animate: 'crossfade',
  navigation: true,
  category_id: @category_blog.id
)

puts 'Uploading slides image for slider'
slides_image = ['slide-1.jpg', 'slide-2.png', 'slide-3.jpg', 'slide-4.jpg']

slide_title_fr = ['Paysage', 'Ordinateur', 'Evénement Sportif']
slide_title_en = ['Landscape', 'Computer', 'Sport Event']
slide_description_fr = [
  'Paysage de montagne',
  '',
  '',
  ''
]
slide_description_en = [
  '',
  '',
  '',
  ''
]

slides_image.each_with_index do |element, index|
  slide = Slide.create!(
    attachable_id: slider.id,
    attachable_type: 'Slider',
    image: File.new("#{Rails.root}/db/seeds/slides/#{element}"),
    title: slide_title_fr[index],
    description: slide_description_fr[index]
  )

  if @locales.include?(:en)
    Slide::Translation.create!(
      slide_id: slide.id,
      locale: 'en',
      title: slide_title_en[index],
      description: slide_description_en[index]
    )
  end
end
