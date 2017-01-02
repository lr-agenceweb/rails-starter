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
end
