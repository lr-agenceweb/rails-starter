#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model
  include Mailable

  attr_accessor :name, :email, :message, :send_copy, :subject, :nickname

  validates :name,
            presence: true
  validates :email,
            presence: true,
            email_format: true
  validates :message,
            presence: true
  validates :nickname,
            absence: true
end
