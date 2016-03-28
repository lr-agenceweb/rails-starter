# frozen_string_literal: true
#
# == HomeSweeper caching
#
class HomeSweeper < ActionController::Caching::Sweeper
  observe Home

  def sweep(home)
    ActionController::Base.new.expire_fragment home
  end

  alias after_update sweep
  alias after_create sweep
  alias after_destroy sweep
end
