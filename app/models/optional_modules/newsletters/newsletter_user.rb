# frozen_string_literal: true

#
# NewsletterUser Model
# ======================
class NewsletterUser < ApplicationRecord
  include Tokenable
  include Scopable
  include Mailable

  # Model relations
  belongs_to :newsletter_user_role
  before_update :prevent_email

  # Accessors
  attr_accessor :nickname # captcha
  attr_accessor :name # name extracted from email

  # Validation rules
  validates :email,
            presence: true,
            uniqueness: true,
            email_format: true

  validates :lang,
            presence: true,
            allow_blank: false,
            inclusion: { in: I18n.available_locales.map(&:to_s) }

  validates :nickname,
            absence: true

  validates :newsletter_user_role_id,
            presence: true,
            inclusion: { in: proc { NewsletterUserRole.all.map(&:id) } }

  # Scopes
  scope :testers, -> { joins(:newsletter_user_role).where('newsletter_user_roles.kind = ?', 'tester') }
  scope :subscribers, -> { joins(:newsletter_user_role).where('newsletter_user_roles.kind = ?', 'subscriber') }

  # Delegates
  delegate :title, :kind, to: :newsletter_user_role, prefix: true, allow_nil: true

  def self.testers?
    !testers.empty?
  end

  private

  def prevent_email
    self.email = email_was if email_changed?
  end
end

# == Schema Information
#
# Table name: newsletter_users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)
#  lang                    :string(255)      default("fr")
#  token                   :string(255)
#  newsletter_user_role_id :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_newsletter_users_on_email                    (email) UNIQUE
#  index_newsletter_users_on_newsletter_user_role_id  (newsletter_user_role_id)
#
