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
                  @calendar_module.enabled? && @event_setting.show_calendar? && json_request?
                }

  decorates_assigned :event

  # GET /events
  # GET /events.json
  def index
    respond_to do |format|
      format.html { set_events }
      format.js { set_events }
      format.json {}
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    redirect_to @event, status: :moved_permanently if request.path != event_path(@event)
    gon.push(
      events: event_path(format: :json),
      single_event: true,
      start_event: @event.start_date,
      end_event: @event.end_date
    )
    seo_tag_show event
  end

  private

  def set_events
    @events = Event.includes_collection.with_conditions.online
    per_p = @setting.per_page == 0 ? @events.count : @setting.per_page
    @events = EventDecorator.decorate_collection(@events.page(params[:page]).per(per_p))

    gon.push(
      events: events_path(format: :json),
      single_event: false
    )

    seo_tag_index category
  end

  def set_event
    @event = Event.includes_collection.online.friendly.find(params[:id])
  end

  def set_calendar_events
    events = Event.includes_collection.online
    @calendar_events = EventDecorator.decorate_collection(events)
  end

  def event_module_enabled?
    not_found unless @event_module.enabled?
  end

  def json_request?
    request.format.symbol == :json
  end
end
