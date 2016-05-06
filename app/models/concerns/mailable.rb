# frozen_string_literal: true

#
# == Mailable module
#
module Mailable
  extend ActiveSupport::Concern

  included do
    unless name == 'ContactForm' # class including Mailable
      scope :not_sent, -> { where(sent_at: nil) }
      scope :sent, -> { where.not(sent_at: nil) }
    end

    def extract_name_from_email
      email.split('@').first
    end

    def sent_at_message
      return I18n.t('newsletter.sent_on', date: I18n.l(sent_at, format: :long)) if already_sent?
      '/'
    end

    def already_sent?
      !sent_at.nil?
    end
  end
end
