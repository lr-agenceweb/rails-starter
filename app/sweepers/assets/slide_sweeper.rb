# frozen_string_literal: true
#
# == SlideSweeper caching
#
class SlideSweeper < ActionController::Caching::Sweeper
  observe Slide

  def sweep(slide)
    ActionController::Base.new.expire_fragment slide
  end

  alias after_update sweep
  alias after_create sweep
  alias after_destroy sweep
end
