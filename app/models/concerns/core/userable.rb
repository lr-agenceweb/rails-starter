# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == Userable module
  #
  module Userable
    extend ActiveSupport::Concern

    included do
      belongs_to :user
      delegate :username, :email, to: :user, prefix: true, allow_nil: true
      scope :by_user, -> (user_id) { where(user_id: user_id) }
    end
  end
end
