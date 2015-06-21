# == Schema Information
#
# Table name: newsletter_users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  lang       :string(255)      default("fr")
#  role       :string(255)      default("subscriber")
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_newsletter_users_on_email  (email) UNIQUE
#

#
# == NewsletterUser Model
#
class NewsletterUser < ActiveRecord::Base
  include Tokenable

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  validates :lang,
            presence: true,
            allow_blank: false,
            inclusion: %w( fr en )

  validates :role,
            presence: true,
            allow_blank: false,
            inclusion: %w( subscriber tester )

  scope :testers, -> { where(role: 'tester') }
  scope :french, -> { where(lang: 'fr') }
  scope :english, -> { where(lang: 'en') }
  scope :by_locale, -> (locale) { where(lang: locale) }

  attr_accessor :name

  def self.testers?
    testers.length > 0
  end
end
