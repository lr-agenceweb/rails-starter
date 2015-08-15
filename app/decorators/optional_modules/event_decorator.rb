#
# == EventDecorator
#
class EventDecorator < PostDecorator
  include Draper::LazyHelpers
  include ActionView::Helpers::DateHelper

  delegate_all
  decorates_association :location

  def url
    if url?
      link_to model.url, model.url, target: :_blank
    else
      'Pas de lien'
    end
  end

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
  # == Location
  #
  def full_address_inline
    model.location.decorate.full_address_inline if location?
  end

  #
  # == Microdata
  #
  def microdata_meta
    h.content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/Event') do
      concat(tag(:meta, itemprop: 'name', content: model.title))
      concat(tag(:meta, itemprop: 'url', content: show_page_link(true)))
      concat(tag(:meta, itemprop: 'startDate', content: model.start_date.to_datetime)) unless model.start_date.nil?
      concat(tag(:meta, itemprop: 'endDate', content: model.end_date.to_datetime)) unless model.end_date.nil?
      concat(tag(:meta, itemprop: 'duration', content: duration))
      concat(tag(:meta, itemprop: 'description', content: model.content))
      concat(h.content_tag(:div, '', itemprop: 'location', itemscope: '', itemtype: 'http://schema.org/Place') do
        concat(tag(:meta, itemprop: 'name', content: model.title))
        concat(h.content_tag(:div, '', itemprop: 'address', itemscope: '', itemtype: 'http://schema.org/PostalAddress') do
          concat(tag(:meta, itemprop: 'streetAddress', content: model.location_address))
          concat(tag(:meta, itemprop: 'addressLocality', content: model.location_city))
          concat(tag(:meta, itemprop: 'postalCode', content: model.location_postcode))
        end)
      end)
    end
  end

  private

  def url?
    !model.url.blank?
  end

  def location?
    !model.location.blank?
  end

  def start_date?
    !model.start_date.blank?
  end

  def end_date?
    !model.end_date.blank?
  end
end
