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
  before_action :set_setting
  before_action :set_map_setting
  before_action :set_contact_settings
  before_action :set_formatted_from

  private

  def set_setting
    @setting = Setting.first
  end

  def set_map_setting
    @map_setting = MapSetting.first.decorate
  end

  def set_contact_settings
    @copy_to_sender = false
  end

  def set_formatted_from
    @from_admin = "#{@setting.name} <#{@setting.email}>"
  end
end
