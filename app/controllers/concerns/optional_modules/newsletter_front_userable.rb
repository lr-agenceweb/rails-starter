#
# == NewsletterFrontUserable Concern
#
module NewsletterFrontUserable
  extend ActiveSupport::Concern

  included do
    before_action :set_newsletter_user, if: proc { @newsletter_module.enabled? }

    def set_newsletter_user
      @newsletter_user ||= NewsletterUser.new
    end
  end
end
