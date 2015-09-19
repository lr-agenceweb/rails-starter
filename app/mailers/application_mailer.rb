#
# == Application Mailer
#
class ApplicationMailer < ActionMailer::Base
  before_action :set_setting
  # layout 'mailer'

  def set_setting
    @settings = Setting.first
  end
end
