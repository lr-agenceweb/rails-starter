#
# == EventsController
#
class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  before_action :event_module_enabled?
  decorates_assigned :event, :comment

  # GET /events
  # GET /events.json
  def index
    @events = EventDecorator.decorate_collection(Event.online.order(created_at: :desc).page params[:page])
    seo_tag_index category
  end

  # GET /event/1
  # GET /event/1.json
  def show
    redirect_to @event, status: :moved_permanently if request.path_parameters[:id] != @event.slug
    seo_tag_show event
  end

  private

  def set_event
    @event = Event.online.includes(pictures: [:translations], referencement: [:translations]).friendly.find(params[:id])
  end

  def event_module_enabled?
    not_found unless @event_module.enabled?
  end
end
