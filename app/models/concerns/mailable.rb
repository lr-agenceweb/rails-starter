#
# == Mailable module
#
module Mailable
  extend ActiveSupport::Concern

  included do
    def extract_name_from_email
      email.split('@').first
    end
  end
end
