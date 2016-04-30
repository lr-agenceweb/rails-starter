# frozen_string_literal: true
#
# == ContactForm Model
#
class ContactForm
  include ActiveModel::Model
  include Mailable

  attr_accessor :name, :email, :message, :send_copy, :subject, :attachment, :nickname

  validates :name,
            presence: true
  validates :email,
            presence: true,
            email_format: true
  validates :message,
            presence: true
  validates :nickname,
            absence: true
  validate :attachment_size_validation,
           unless: proc { attachment.blank? }
  validate :attachment_type_validation,
           unless: proc { attachment.blank? }

  def attachment_size_validation
    max_size = 3
    errors[:attachment] << I18n.t('form.errors.contact_form.size', size: max_size) if attachment.size > max_size.megabytes
  end

  def attachment_type_validation
    acceptable_types = ['application/pdf', 'image/jpeg', 'image/png', 'text/plain']
    errors[:attachment] << I18n.t('form.errors.contact_form.type') unless acceptable_types.include? attachment.content_type.chomp
  end
end
