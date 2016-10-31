# frozen_string_literal: true

#
# == Map Setting
#
puts 'Creating MapSetting'
map_setting = MapSetting.new(
  marker_icon: 'park',
  marker_color: '#ee3e3e',
  show_map: true
)
map_setting.save

# Location
set_location(map_setting, 'MapSetting')
