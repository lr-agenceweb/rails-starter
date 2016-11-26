# frozen_string_literal: true

#
# ContactForm Model
# =======================
class ContactForm
  include ActiveModel::Model
  include Mailable

  attr_accessor :name, :email, :message, :send_copy, :attachment, :nickname

  I18N_SCOPE = 'activerecord.errors.models.contact_form.attributes.attachment'
  ATTACHMENT_MAX_SIZE = 3 # megabytes
  ATTACHMENT_TYPES = ['application/pdf', 'image/jpeg', 'image/png', 'text/plain'].freeze

  validates :name,
            presence: true
  validates :email,
            presence: true,
            email_format: true
  validates :message,
            presence: true
  validates :nickname,
            absence: true
  validate :attachment_size,
           unless: proc { attachment.blank? }
  validate :attachment_type,
           unless: proc { attachment.blank? }

  def attachment_size
    errors[:attachment] << I18n.t('size', size: ATTACHMENT_MAX_SIZE, scope: I18N_SCOPE) if attachment.size > ATTACHMENT_MAX_SIZE.megabytes
  end

  def attachment_type
    errors[:attachment] << I18n.t('type', scope: I18N_SCOPE) unless ATTACHMENT_TYPES.include? attachment.content_type.chomp
  end
end
