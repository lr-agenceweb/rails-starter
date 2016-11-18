# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
run Rails.application

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We're in smart spawning mode.
      Rails.cache.instance_variable_get(:@data).reset if Rails.cache.class == ActiveSupport::Cache::MemCacheStore
    end
  end
end
