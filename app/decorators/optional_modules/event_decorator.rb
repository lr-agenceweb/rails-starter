#
# == EventDecorator
#
class EventDecorator < PostDecorator
  include Draper::LazyHelpers
  include ActionView::Helpers::DateHelper
  delegate_all

  def url
    if url?
      link_to model.url, model.url, target: :_blank
    else
      'Pas de lien'
    end
  end

  def duration
    distance_of_time_in_words(model.end_date, model.start_date)
  end

  private

  def url?
    !model.url.blank?
  end
end
