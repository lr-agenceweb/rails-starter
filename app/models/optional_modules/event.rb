# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  content    :text(65535)
#  url        :string(255)
#  start_date :datetime
#  end_date   :datetime
#  online     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_events_on_slug  (slug)
#

#
# == Event model
#
class Event < ActiveRecord::Base
  include Imageable

  translates :title, :slug, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :slug, :content, fallbacks_for_empty_translations: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :globalize, :finders]

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  has_many :pictures, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  validate :calendar_date_correct?, unless: proc { end_date.blank? && start_date.blank? }
  validates :url, allow_blank: true, url: true

  delegate :online, to: :pictures, prefix: true, allow_nil: true
  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }

  def calendar_date_correct?
    if end_date <= start_date
      errors.add :start_date, I18n.t('form.errors.start_date')
      errors.add :end_date, I18n.t('form.errors.end_date')
    end
  end
end
