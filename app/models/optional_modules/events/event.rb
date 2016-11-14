# frozen_string_literal: true
# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  slug            :string(255)
#  all_day         :boolean          default(FALSE)
#  start_date      :datetime
#  end_date        :datetime
#  show_as_gallery :boolean          default(FALSE)
#  show_calendar   :boolean          default(FALSE)
#  show_map        :boolean          default(FALSE)
#  online          :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_events_on_slug  (slug)
#

#
# == Event model
#
class Event < ApplicationRecord
  include Core::Referenceable
  include Core::DateConstraintable
  include Core::FriendlyGlobalizeSluggable
  include Includes::EventIncludable
  include OptionalModules::Assets::Imageable
  include OptionalModules::Assets::VideoPlatformable
  include OptionalModules::Assets::VideoUploadable
  include OptionalModules::Locationable
  include OptionalModules::Searchable
  include PrevNextable
  include Linkable

  # Constantes
  EVENT_START = 9 # 9:00
  EVENT_END = 18 # 18:00
  I18N_SCOPE = 'activerecord.errors.models.event.attributes'

  # Callbacks
  before_validation :reset_end_date,
                    if: proc { all_day? && start_date.present? }
  before_validation :check_all_day,
                    if: proc { end_date.blank? }

  # Validation rules
  validates :start_date, presence: true
  validate :date_constraints, if: :calendar_dates?

  # Scopes
  scope :online, -> { where(online: true) }
  scope :published, -> { online }
  scope :current_or_coming, -> { where('(start_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date = ? AND all_day = ?)', Time.zone.now, Time.zone.now, Time.zone.now, Time.zone.today, true) }

  def self.with_conditions
    event_order = EventSetting.first.event_order
    return current_or_coming.order(start_date: :asc) if event_order.key == 'current_or_coming'
    order(start_date: :desc)
  end

  private

  def reset_end_date
    self.end_date = nil
  end

  def check_all_day
    self.all_day = true
  end
end
