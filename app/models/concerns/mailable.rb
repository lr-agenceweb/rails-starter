#
# == Mailable module
#
module Mailable
  extend ActiveSupport::Concern

  included do
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
