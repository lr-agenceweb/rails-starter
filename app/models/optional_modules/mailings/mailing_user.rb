# frozen_string_literal: true

# == Schema Information
#
# Table name: mailing_users
#
#  id         :integer          not null, primary key
#  fullname   :string(255)
#  email      :string(255)
#  token      :string(255)
#  lang       :string(255)
#  archive    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == MailingUser Model
#
class MailingUser < ActiveRecord::Base
  include Tokenable
  include Mailable

  has_many :mailing_messages, through: :mailing_message_users
  has_many :mailing_message_users, dependent: :destroy

  scope :archive, -> { where(archive: true) }
  scope :not_archive, -> { where.not(archive: true) }

  validates :email,
            presence: true,
            uniqueness: true,
            email_format: true

  validates :lang,
            presence: true,
            allow_blank: false,
            inclusion: I18n.available_locales.map(&:to_s)

  def name
    "#{email} <small>(#{fullname}) #{decorate.lang} #{decorate.archive_status}</small>".html_safe
  end
end
