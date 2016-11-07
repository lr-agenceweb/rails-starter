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
# PublicationDate Model
# ========================
class PublicationDate < ApplicationRecord
  include Core::DateConstraintable

  # Callbacks
  before_save :reset_published_at, unless: :published_later?
  before_save :reset_expired_at, unless: :expired_prematurely?

  # Model relations
  belongs_to :publishable, polymorphic: true, touch: true

  # Constants
  I18N_SCOPE = 'activerecord.errors.models.publication_date.attributes'

  # Validation rules
  validates :published_at,
            presence: true,
            allow_blank: false,
            if: :published_later?
  validates :expired_at,
            presence: true,
            allow_blank: false,
            if: :expired_prematurely?
  validate :date_constraints,
           if: :publication_dates?
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

  def error_for_past_dates(key, i18n)
    today = DateTime.current
    errors.add key.to_sym, I18n.t("past_#{i18n}", scope: I18N_SCOPE) if send(key) && send(key) < today
  end
end
