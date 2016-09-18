# frozen_string_literal: true

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == Postable
  #
  module Postable
    extend ActiveSupport::Concern

    included do
      before_create do |post|
        post.type = post.class.name
        post.user_id = current_user.id
      end
    end
  end
end
