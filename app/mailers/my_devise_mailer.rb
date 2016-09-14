# frozen_string_literal: true

#
# == MyDevise Mailer
#
class MyDeviseMailer < Devise::Mailer
  before_action :set_setting

  def confirmation_instructions(record, token, opts = {})
    super
  end

  def password_change(record, opts = {})
    super
  end

  def reset_password_instructions(record, token, opts = {})
    super
  end

  def unlock_instructions(record, token, opts = {})
    super
  end

  private

  def set_setting
    @setting = Setting.first
  end
end
