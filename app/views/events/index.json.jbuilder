# frozen_string_literal: true
json.array! @calendar_events do |event|
  json.title event.title
  json.url event_path(event)

  # Dates
  json.start event.start_date.to_date
  json.end event.end_date.to_date unless event.all_day?
end
