# frozen_string_literal: true

#
# == EventsController
#
class EventsController < ApplicationController
  include ModuleSettingable

  # Callbacks
  before_action :event_module_enabled?
  before_action :set_event, only: [:show]
  before_action :set_calendar_events,
                only: [:index],
                if: proc {
                  @calendar_module.enabled? && @event_setting.show_calendar?
                }

  decorates_assigned :event, :comment

  # GET /events
  # GET /events.json
  def index
    @events = Event.includes_collection.with_conditions.online
    per_p = @setting.per_page == 0 ? @events.count : @setting.per_page
    @events = EventDecorator.decorate_collection(@events.page(params[:page]).per(per_p))
    gon.push(events: events_path(format: :json))
    seo_tag_index category
  end

  # GET /events/1
  # GET /events/1.json
  def show
    redirect_to @event, status: :moved_permanently if request.path != event_path(@event)
    gon.push(events: event_path(format: :json))
    seo_tag_show event
  end

  private

  def set_event
    @event = Event.includes_collection.online.friendly.find(params[:id])
  end

  def set_calendar_events
    @calendar_events = Event.includes_collection.online
  end

  def event_module_enabled?
    not_found unless @event_module.enabled?
  end
end
