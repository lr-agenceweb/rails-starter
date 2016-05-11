# frozen_string_literal: true

#
# == Module Users
#
module Users
  #
  # == Activable module
  #
  module RegisterActivable
    extend ActiveSupport::Concern

    included do
      devise :registerable

      # Override devise method to ensure account is activated
      def active_for_authentication?
        super && account_active?
      end
    end
  end
end
