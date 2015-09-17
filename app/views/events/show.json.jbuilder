json.array! [@event] do
  json.title @event.title
  json.start @event.start_date
  json.end @event.end_date
end