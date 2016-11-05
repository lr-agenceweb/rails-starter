# frozen_string_literal: true

# Core
json.title event.title
json.url event_path(event)
json.cover event.custom_cover

# Dates
if event.all_day?
  json.start event.start_date
  json.end event.start_date.change(hour: Event::EVENT_END)
else
  json.start event.start_date.to_date
  json.end event.end_date.to_date
end
