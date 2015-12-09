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

  scope :archive, -> { where(archive: true) }
  scope :not_archive, -> { where.not(archive: true) }

  validates :email,
            presence: true,
            uniqueness: true,
            email_format: true

  validates :lang,
            presence: true,
            allow_blank: false,
            inclusion: %w( fr en )

  def name
    "#{email} <small>(#{fullname}) #{self.decorate.archive_status}</small>".html_safe
  end
end
