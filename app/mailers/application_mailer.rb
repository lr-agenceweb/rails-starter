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
    @map = Map.joins(:location).select('locations.id, locations.address, locations.city, locations.postcode').first
    @copy_to_sender = false
  end
end
