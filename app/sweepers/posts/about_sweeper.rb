# frozen_string_literal: true
#
# == AboutSweeper caching
#
class AboutSweeper < ActionController::Caching::Sweeper
  observe About

  def sweep(about)
    ActionController::Base.new.expire_fragment about
    ActionController::Base.new.expire_fragment ['list', about]
  end

  alias after_update sweep
  alias after_create sweep
  alias after_destroy sweep
end
