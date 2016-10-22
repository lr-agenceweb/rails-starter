# frozen_string_literal: true

# Post
def set_title
  Faker::Hipster.sentence(3, false, 1)
end

def set_content
  "<p>#{Faker::Hipster.paragraph(10, true, 4)}</p>"
end

# Picture
def set_picture(resource, type, url = false)
  download = url == false ? open('https://unsplash.it/1000/600/?random') : open(url)
  file_path = Rails.root.join('public', 'image.jpg')
  IO.copy_stream(download, file_path)

  Picture.create!(
    attachable_id: resource.id,
    attachable_type: type,
    image: File.new(file_path)
  )
end

# Background
def set_background(resource, type)
  download = open('http://lorempixel.com/1900/1200/nature/')
  file_path = Rails.root.join('public', 'image.jpg')
  IO.copy_stream(download, file_path)

  Background.create!(
    attachable_id: resource.id,
    attachable_type: type,
    image: File.new(file_path)
  )
end

# Audio
def set_audio(resource, type, url)
  download = open(url)
  file_path = Rails.root.join('public', 'audio.mp3')
  IO.copy_stream(download, file_path)

  Audio.create!(
    audioable_id: resource.id,
    audioable_type: type,
    audio: File.new(file_path)
  )
end

def set_video_upload(resource, type, url)
  download = open(url)
  file_path = Rails.root.join('public', 'video.mp4')
  IO.copy_stream(download, file_path)

  video_upload = VideoUpload.new(
    videoable_id: resource.id,
    videoable_type: type,
    video_file: File.new(file_path)
  )
  video_upload.save
  video_upload
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
