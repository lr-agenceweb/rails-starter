#
# == ContactForm Model
#
class ContactForm < MailForm::Base
  attribute :name
  attribute :email
  attribute :message
  attribute :nickname, captcha: true # used to cheat spam robots

  validates :name, presence: true
  validates :message, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  append :remote_ip, :user_agent

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
