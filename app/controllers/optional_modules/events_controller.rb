#
# == EventsController
#
class EventsController < ApplicationController
  before_action :event_module_enabled?
  before_action :set_event, only: [:show]
  decorates_assigned :event, :comment

  # GET /events
  # GET /events.json
  def index
    @events = Event.with_conditions.online.includes(:translations, :location)
    per_p = @setting.per_page == 0 ? @events.count : @setting.per_page
    @events = EventDecorator.decorate_collection(@events.page(params[:page]).per(per_p))
    seo_tag_index category
  end

  # GET /event/1
  # GET /event/1.json
  def show
    redirect_to @event, status: :moved_permanently if request.path_parameters[:id] != @event.slug
    gon.push(event_path: event_path(format: :json))
    @event_settings = EventSetting.first
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
