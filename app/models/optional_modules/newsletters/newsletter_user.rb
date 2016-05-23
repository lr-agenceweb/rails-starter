# frozen_string_literal: true

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

#
# == NewsletterUser Model
#
class NewsletterUser < ActiveRecord::Base
  include Tokenable
  include Scopable
  include Mailable

  belongs_to :newsletter_user_role

  attr_accessor :nickname # captcha
  attr_accessor :name # name extracted from email

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

  scope :testers, -> { joins(:newsletter_user_role).where('newsletter_user_roles.kind = ?', 'tester') }
  scope :subscribers, -> { joins(:newsletter_user_role).where('newsletter_user_roles.kind = ?', 'subscriber') }

  delegate :title, :kind, to: :newsletter_user_role, prefix: true, allow_nil: true

  def self.testers?
    !testers.empty?
  end
end
