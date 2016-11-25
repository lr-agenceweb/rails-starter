# frozen_string_literal: true

# Utils
def download_and_unzip(name)
  download = open("https://s3-us-west-2.amazonaws.com/coverr/zip/#{name}.zip")
  folder_path = "#{@tmp_path}/#{name}"
  zip_file_path = "#{@tmp_path}/#{name}.zip"
  mp4_path = "#{@tmp_path}/#{name}.mp4"
  IO.copy_stream(download, zip_file_path)

  system("unzip -o #{zip_file_path} -d #{folder_path}; cd #{folder_path}/MP4; mv #{name}.mp4 ../..")

  mp4_path
end

# Post
def set_title
  Faker::Hipster.sentence(3, false, 1).gsub('.', '')
end

def set_content(size: 10, paragraph: 5)
  html = []
  paragraph.times do |i|
    html << ActionView::Helpers::TagHelper.content_tag(:p, Faker::Hipster.paragraph(size, true, 1))
  end
  safe_join [html]
end

# Avatar
def set_avatar(slug: 'lorem-ipsum')
  download = open(Faker::Avatar.image(slug))
  file_path = "#{@tmp_path}/image.jpg"
  IO.copy_stream(download, file_path)
  File.new(file_path)
end

# Picture
def set_picture(resource, type, url = false)
  download = url == false ? open('http://lorempixel.com/1000/600/') : open(url)
  file_path = "#{@tmp_path}/image.jpg"
  IO.copy_stream(download, file_path)

  Picture.create!(
    attachable_id: resource.id,
    attachable_type: type,
    image: File.new(file_path)
  )
rescue
  puts 'ALERT :: Error while downloading picture'
end

# Background
def set_background(resource, type)
  download = open('http://lorempixel.com/1900/1200/')
  file_path = "#{@tmp_path}/image.jpg"
  IO.copy_stream(download, file_path)

  Background.create!(
    attachable_id: resource.id,
    attachable_type: type,
    image: File.new(file_path)
  )
rescue
  puts 'ALERT :: Error while downloading background picture'
end

# Audio
def set_audio(resource, type, url, name = 'audio')
  download = open(url)
  file_path = "#{@tmp_path}/#{name}.mp3"
  IO.copy_stream(download, file_path)

  Audio.create!(
    audioable_id: resource.id,
    audioable_type: type,
    audio: File.new(file_path)
  )
rescue
  puts 'ALERT :: Error while downloading audio file'
end

# VideoUpload
def set_video_upload(resource, type, url)
  download = open(url)
  file_path = "#{@tmp_path}/video.mp4"
  IO.copy_stream(download, file_path)

  video_upload = VideoUpload.new(
    videoable_id: resource.id,
    videoable_type: type,
    video_file: File.new(file_path)
  )
  video_upload.save
  video_upload
rescue
  puts 'ALERT :: Error while downloading video_upload'
end

# Referencement
def set_referencement(resource, type)
  referencement = Referencement.create!(
    attachable_id: resource.id,
    attachable_type: type,
    title: Faker::Lorem.words(5).join(' '),
    description: Faker::Lorem.paragraph(2, false, 4),
    keywords: Faker::Lorem.words(10).join(', ')
  )

  if @locales.include?(:en)
    Referencement::Translation.create!(
      referencement_id: referencement.id,
      locale: 'en',
      title: Faker::Lorem.words(5).join(' '),
      description: Faker::Lorem.paragraph(2, false, 4),
      keywords: Faker::Lorem.words(10).join(', ')
    )
  end
end

# Location
def set_location(resource, type)
  address = Faker::Address.street_address
  postcode = Faker::Address.postcode
  city = Faker::Address.city

  Location.create!(
    locationable_id: resource.id,
    locationable_type: type,
    address: address,
    city: city,
    postcode: postcode,
    geocode_address: "#{address} #{postcode} #{city}",
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  )
end
