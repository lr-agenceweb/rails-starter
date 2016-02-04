#
# == EventDecorator
#
class EventDecorator < PostDecorator
  include Draper::LazyHelpers
  include ActionView::Helpers::DateHelper

  delegate_all
  decorates_association :location

  def url
    url? ? link_to(model.url, model.url, target: :_blank) : 'Pas de lien'
  end

  #
  # == Dates
  #
  def duration
    distance_of_time_in_words(model.end_date, model.start_date) if start_date? && end_date?
  end

  def start_date_deco
    time_tag model.start_date.to_datetime, l(model.start_date, format: :without_time_no_year) if start_date?
  end

  def end_date_deco
    time_tag model.end_date.to_datetime, l(model.end_date, format: :without_time) if end_date?
  end

  def from_to_date
    I18n.t('event.from_to_date', start_date: start_date_deco, end_date: end_date_deco) if start_date? && end_date?
  end

  #
  # == Calendar
  #
  def all_conditions_to_show_calendar?(calendar_module)
    model.show_calendar? && calendar_module.enabled? && start_date? && end_date?
  end

  def show_calendar_d
    color = model.show_calendar? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_calendar}"), color
  end

  #
  # == Location
  #
  def full_address_inline
    model.location.decorate.full_address_inline if location?
  end

  private

  def url?
    !model.url.blank?
  end

  def start_date?
    !model.start_date.blank?
  end

  def end_date?
    !model.end_date.blank?
  end
end
