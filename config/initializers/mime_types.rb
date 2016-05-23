# frozen_string_literal: true

# Video
Mime::Type.register 'video/mp4', :mp4
Mime::Type.register 'video/mp4', :m4v
Mime::Type.register 'video/webm', :webm
Mime::Type.register 'video/ogg', :ogv
Mime::Type.register 'application/ogg', :ogg
Mime::Type.register 'application/ogg', :ogx

# Audio
Mime::Type.register 'audio/mpeg', :mp3
Mime::Type.register 'audio/mpeg', :m4a
Mime::Type.register 'audio/ogg', :oga

# Subtitle
Mime::Type.register 'text/srt', :srt
Mime::Type.register 'text/vtt', :vtt
