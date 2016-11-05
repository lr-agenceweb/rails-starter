# frozen_string_literal: true

#
# == Blog Setting
#
puts 'Creating BlogSetting'
BlogSetting.create!(
  prev_next: true,
  show_last_comments: true
)
