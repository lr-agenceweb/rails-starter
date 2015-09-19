#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model
  include Mailable

  attr_accessor :name, :email, :message, :send_copy, :subject, :nickname

  validates :name, :message, :email, presence: true
  validates :email, email_format: true
end
