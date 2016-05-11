# frozen_string_literal: true

#
# == Application Mailer
#
class ApplicationMailer < ActionMailer::Base
  before_action :set_setting
  before_action :set_contact_settings

  private

  def set_setting
    @setting = Setting.first
  end

  def set_contact_settings
    @copy_to_sender = false
  end
end
