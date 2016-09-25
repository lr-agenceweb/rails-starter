# frozen_string_literal: true

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == Cachable
  #
  module Cachable
    extend ActiveSupport::Concern

    included do
      sweeper = "#{name.demodulize.gsub('Controller', '').underscore.singularize}_sweeper"
      cache_sweeper sweeper.to_sym
    end
  end
end
