# frozen_string_literal: true
#
# == LegalNoticeSweeper caching
#
class LegalNoticeSweeper < ActionController::Caching::Sweeper
  observe LegalNotice

  def sweep(legal_notice)
    ActionController::Base.new.expire_fragment legal_notice
  end

  alias after_update sweep
  alias after_create sweep
  alias after_destroy sweep
end
