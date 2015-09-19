#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model

  attr_accessor :name, :email, :message, :send_copy, :subject, :nickname

  validates :name, :message, :email, presence: true
  validates :email, email_format: true

  def extract_name_from_email
    email.split('@').first
  end
end
