# frozen_string_literal: true

#
# NewsletterSetting Model
# =========================
class NewsletterSetting < ApplicationRecord
  include MaxRowable

  # Translations
  translates :title_subscriber, :content_subscriber, fallbacks_for_empty_translations: true
  active_admin_translates :title_subscriber, :content_subscriber

  # Model relations
  has_many :newsletter_user_roles, as: :rollable, dependent: :destroy
  accepts_nested_attributes_for :newsletter_user_roles, reject_if: :all_blank, allow_destroy: true

  # Validation rules
  validates_associated :newsletter_user_roles
end

# == Schema Information
#
# Table name: newsletter_settings
#
#  id                 :integer          not null, primary key
#  send_welcome_email :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
