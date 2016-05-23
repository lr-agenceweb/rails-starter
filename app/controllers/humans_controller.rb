# frozen_string_literal: true

#
# == HumansController
#
class HumansController < ApplicationController
  include Skippable
  layout false

  before_action :last_deploy

  def index
  end

  private

  def last_deploy
    file = File.open 'REVISION'
    @last_deploy = l(file.ctime, locale: :en)
  rescue
    @last_deploy = l(Time.zone.now, locale: :en)
  end
end
