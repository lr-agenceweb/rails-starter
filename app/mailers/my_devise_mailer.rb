# frozen_string_literal: true

#
# MyDevise Mailer
# =================
class MyDeviseMailer < Devise::Mailer
  before_action :set_setting

  def password_change(record, opts = {})
    fix_headers(opts)
    super
  end

  def reset_password_instructions(record, token, opts = {})
    fix_headers(opts)
    super
  end

  # def confirmation_instructions(record, token, opts = {})
  #   fix_headers(opts)
  #   super
  # end
  #
  # def unlock_instructions(record, token, opts = {})
  #   fix_headers(opts)
  #   super
  # end

  private

  def set_setting
    @setting = Setting.first
  end

  def fix_headers(opts)
    opts[:from] = @setting.email
    opts[:reply_to] = @setting.email
  end
end
