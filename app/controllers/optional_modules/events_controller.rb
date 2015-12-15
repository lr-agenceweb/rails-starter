#
# == EventsController
#
class EventsController < ApplicationController
  before_action :not_found, unless: proc { @event_module.enabled? }
  before_action :set_event, only: [:show]
  decorates_assigned :event, :comment

  # GET /events
  # GET /events.json
  def index
    per_p = Event.count
    per_p = @setting.per_page unless @setting.per_page == 0
    @events = Event.with_conditions.includes(:translations, :location).online.page(params[:page]).per(per_p)
    @events = EventDecorator.decorate_collection(@events)
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
end
