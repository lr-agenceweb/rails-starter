# frozen_string_literal: true
#
# == EventSweeper caching
#
class EventSweeper < ActionController::Caching::Sweeper
  observe Event

  def sweep(event)
    ActionController::Base.new.expire_fragment event
  end

  alias after_update sweep
  alias after_create sweep
  alias after_destroy sweep
end
