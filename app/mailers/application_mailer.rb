# frozen_string_literal: true

#
# Application Mailer
# ====================
class ApplicationMailer < ActionMailer::Base
  include SharedColoredVariables

  # Helpers
  helper :html # HtmlHelper
  helper :application # ApplicationHelper

  # Callbacks
  before_action :set_setting,
                :set_map_setting,
                :set_mailing_setting,
                :set_contact_setting,
                :set_formatted_from

  private

  def set_setting
    @setting = Setting.first
  end

  def set_map_setting
    @map_setting = MapSetting.first.decorate
  end

  def set_mailing_setting
    @mailing_setting = MailingSetting.first.decorate
  end

  def set_contact_setting
    @copy_to_sender = false
  end

  def set_formatted_from
    @from_admin = "#{@setting.name} <#{@setting.email}>"
  end
end
