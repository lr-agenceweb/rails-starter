#
# == Omniauthable module
#
module Omniauthable
  extend ActiveSupport::Concern

  included do
    def self.find_by_provider_and_uid(auth)
      find_by(provider: auth.provider, uid: auth.uid)
    end

    def link_with_omniauth(auth)
      unless provider == auth.provider && uid == auth.uid
        update_attributes(
          provider: auth.provider,
          uid: auth.uid
        )
      end
      update_attributes(
        username: username_for_omniauth(auth),
        avatar: auth.info.image? ? URI.parse(process_uri(auth.info.image)) : nil
      )
      self
    end

    def from_omniauth?
      !(provider.blank? && uid.blank?)
    end

    def self.check_for_errors(auth, current_user)
      errors = {}
      errors[:wrong_email] = I18n.t('omniauth.email.not_match', provider: auth.provider.capitalize) if auth.info.email != current_user.email
      errors[:already_linked] = I18n.t('omniauth.email.already_linked', provider: auth.provider.capitalize) if current_user.from_omniauth?
      errors
    end

    private

    def username_for_omniauth(auth)
      User.where.not(id: id).exists?(username: auth.info.name) ? "#{auth.info.name} #{auth.uid}" : auth.info.name
    end
  end
end
