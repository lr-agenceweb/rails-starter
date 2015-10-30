#
# == SocialableConcern
#
module Socialable
  extend ActiveSupport::Concern

  included do
    before_action :set_socials_network, if: proc { @social_module.enabled? }

    def set_socials_network
      socials_all = Social.enabled
      @socials_follow = socials_all.follow
      @socials_share = socials_all.share
    end
  end
end
