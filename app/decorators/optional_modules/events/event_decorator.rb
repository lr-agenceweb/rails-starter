# frozen_string_literal: true
#
# == EventDecorator
#
class EventDecorator < PostDecorator
  include Draper::LazyHelpers
  include ActionView::Helpers::DateHelper

  delegate_all
  decorates_association :location

  #
  # == Dates
  #
  def duration
    distance_of_time_in_words(model.end_date, model.start_date) if start_date? && end_date?
  end

  def start_date_deco(format = :without_time_no_year)
    time_tag model.start_date.to_datetime, l(model.start_date, format: format) if start_date?
  end

  def end_date_deco(format = :without_time)
    time_tag model.end_date.to_datetime, l(model.end_date, format: format) if end_date?
  end

  def from_to_date
    return I18n.t('event.from_to_date', start_date: start_date_deco, end_date: end_date_deco) if start_date? && end_date? && !all_day?
    start_date_deco(:without_time) if start_date? && all_day?
  end

  #
  # == Calendar
  #
  def all_conditions_to_show_calendar?(calendar_module)
    model.show_calendar? && calendar_module.enabled? && start_date? && end_date?
  end

  #
  # == Location
  #
  def full_address_inline
    model.location.decorate.full_address_inline if location?
  end

  private

  def start_date?
    !model.start_date.blank?
  end

  def end_date?
    !model.end_date.blank?
  end
end
