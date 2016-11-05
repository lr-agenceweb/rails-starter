# frozen_string_literal: true

json.array! @calendar_events, partial: 'events/event', as: :event
