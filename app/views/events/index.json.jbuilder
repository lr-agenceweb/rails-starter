# frozen_string_literal: true
json.array! @calendar_events do |event|
  json.title event.title
  json.url event_path(event)

  if event.all_day?
    json.start event.start_date.to_date
  else
    json.start event.start_date
    json.end event.end_date
  end
end
