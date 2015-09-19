#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model

  attr_accessor :name, :email, :message, :send_copy, :nickname

  validates :name, :message, :email, presence: true
  validates :email, email_format: true
end
