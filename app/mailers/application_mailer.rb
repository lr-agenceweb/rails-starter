#
# == Application Mailer
#
class ApplicationMailer < ActionMailer::Base
  before_action :set_setting

  def set_setting
    @setting = Setting.first
  end
end
