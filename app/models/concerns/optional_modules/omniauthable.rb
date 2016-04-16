# frozen_string_literal: true
#
# == Module OptionalModules
#
module OptionalModules
  #
  # == Omniauthable module
  #
  module Omniauthable
    extend ActiveSupport::Concern

    included do
      def self.find_by_provider_and_uid(auth)
        formatted_provider = SocialProvider.format_provider_by_name(auth.provider)
        find_by(provider: formatted_provider, uid: auth.uid)
      end

      def link_with_omniauth(auth)
        formatted_provider = SocialProvider.format_provider_by_name(auth.provider)
        unless provider == formatted_provider && uid == auth.uid
          update_attributes(
            provider: formatted_provider,
            uid: auth.uid
          )
        end
        update_infos_since_last_connection(auth)
        self
      end

      def update_infos_since_last_connection(auth)
        update_attributes(username: username_for_omniauth(auth)) if username != auth.info.name
        if auth.info.image? && avatar_file_name != File.basename(URI.parse(auth.info.image).path)
          update_attributes(avatar: URI.parse(process_uri(auth.info.image)))
        end
        self
      end

      def from_omniauth?(kind = 'facebook')
        !(provider.blank? && uid.blank?) && provider == kind
      end

      def self.check_for_errors(auth, current_user)
        errors = {}
        errors[:wrong_email] = I18n.t('omniauth.email.not_match', provider: auth.provider.capitalize) if auth.info.email != current_user.email && auth.provider != 'twitter'
        errors[:already_linked] = I18n.t('omniauth.email.already_linked', provider: auth.provider.capitalize) if current_user.from_omniauth?(auth.provider)
        errors
      end

      private

      def username_for_omniauth(auth)
        User.where.not(id: id).exists?(username: auth.info.name) ? "#{auth.info.name} #{auth.uid}" : auth.info.name
      end
    end
  end
end
