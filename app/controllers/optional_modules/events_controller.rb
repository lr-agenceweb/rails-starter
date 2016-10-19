# frozen_string_literal: true

#
# == EventsController
#
class EventsController < ApplicationController
  include ModuleSettingable
  before_action :event_module_enabled?
  before_action :set_event, only: [:show]

  decorates_assigned :event, :comment

  # GET /events
  # GET /events.json
  def index
    @events = Event.includes_collection.with_conditions.online
    per_p = @setting.per_page == 0 ? @events.count : @setting.per_page
    @events = EventDecorator.decorate_collection(@events.page(params[:page]).per(per_p))
    seo_tag_index category
  end

  # GET /events/1
  # GET /events/1.json
  def show
    redirect_to @event, status: :moved_permanently if request.path != event_path(@event)
    gon.push(event_path: event_path(format: :json))
    seo_tag_show event
  end

  private

  def set_event
    @event = Event.includes_collection.online.friendly.find(params[:id])
  end

  def event_module_enabled?
    not_found unless @event_module.enabled?
  end
end
