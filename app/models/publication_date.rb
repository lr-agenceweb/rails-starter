# frozen_string_literal: true

# == Schema Information
#
# Table name: publication_dates
#
#  id                  :integer          not null, primary key
#  publishable_id      :integer
#  publishable_type    :string(255)
#  published_later     :boolean          default(FALSE)
#  expired_prematurely :boolean          default(FALSE)
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_publication_dates_on_publishable_type_and_publishable_id  (publishable_type,publishable_id)
#

#
# == PublicationDate Model
#
class PublicationDate < ActiveRecord::Base
  # Callbacks
  before_save :reset_published_at, unless: :published_later?
  before_save :reset_expired_at, unless: :expired_prematurely?

  # Model relations
  belongs_to :publishable, polymorphic: true, touch: true

  # Validation rules
  validates :published_at,
            presence: true,
            allow_blank: false,
            if: :published_later?
  validates :expired_at,
            presence: true,
            allow_blank: false,
            if: :expired_prematurely?
  validate :publication_dates,
           if: :validate_publication_dates?
  validate :no_past_publication,
           if: proc { |rec| rec.new_record? || rec.published_at_changed? }
  validate :no_past_expiration,
           if: proc { |rec| rec.new_record? || rec.expired_at_changed? }

  private

  def reset_published_at
    self.published_at = nil
  end

  def reset_expired_at
    self.expired_at = nil
  end

  def no_past_publication
    error_for_past_dates('published_at', 'publication')
  end

  def no_past_expiration
    error_for_past_dates('expired_at', 'expiration')
  end

  def publication_dates
    return true unless expired_at <= published_at
    scope = 'form.errors.publication_date'
    errors.add :published_at, I18n.t('published_at', scope: scope)
    errors.add :expired_at, I18n.t('expired_at', scope: scope)
  end

  def validate_publication_dates?
    !(published_at.blank? || expired_at.blank?)
  end

  def error_for_past_dates(key, i18n)
    today = DateTime.current
    scope = 'form.errors.publication_date'
    errors.add key.to_sym, I18n.t("no_past_#{i18n}", scope: scope) if send(key) && send(key) < today
  end
end
