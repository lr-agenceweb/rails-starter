#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model
  include Mailable

  attr_accessor :name, :email, :message, :send_copy, :subject, :nickname

  validates :name,
            presence: { message: I18n.t('activerecord.errors.models.contact_form.attributes.name.blank') }
  validates :email,
            presence: { message: I18n.t('activerecord.errors.models.contact_form.attributes.email.blank') },
            email_format: true
  validates :message,
            presence: { message: I18n.t('activerecord.errors.models.contact_form.attributes.message.blank') }
end
