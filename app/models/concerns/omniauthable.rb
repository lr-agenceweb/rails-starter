#
# == Omniauthable module
#
module Omniauthable
  extend ActiveSupport::Concern

  included do
    def self.find_by_provider_and_uid(auth)
      find_by(provider: auth.provider, uid: auth.uid)
    end

    def self.link_with_omniauth(auth, current_user)
      unless current_user.provider == auth.provider && current_user.uid == auth.uid
        current_user.update_attributes(
          provider: auth.provider,
          uid: auth.uid
        )
      end
      current_user.update_attributes(
        username: username_for_omniauth(auth, current_user),
        avatar: auth.info.image? ? URI.parse(process_uri(auth.info.image)) : nil
      )
      current_user
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

    def self.username_for_omniauth(auth, current_user)
      User.where.not(id: current_user.id).exists?(username: auth.info.name) ? "#{auth.info.name} #{auth.uid}" : auth.info.name
    end
  end
end
