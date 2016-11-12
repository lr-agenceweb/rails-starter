# frozen_string_literal: true

#
# Application Job
# ====================
class ApplicationJob < ActiveJob::Base
  queue_as :default
end
