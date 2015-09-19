#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model

  attr_accessor :name, :email, :message, :send_copy, :nickname

  validates :name, :message, :email, presence: true
  validates :email, email_format: true

  # Declaration of the e-mail headers.
  def headers
    settings = Setting.first
    {
      subject: "Contact depuis #{settings.title}",
      from: %("#{name}" <#{email}>),
      to: settings.email,
      bcc: email
    }
  end
end
