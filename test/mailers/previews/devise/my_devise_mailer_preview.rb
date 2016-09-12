# frozen_string_literal: true

#
# == Devise namespace
#
module Devise
  #
  # == MyDevise Mailer Preview
  #
  class MyDeviseMailerPreview < ActionMailer::Preview
    # hit http://localhost:3000/rails/mailers/devise/mailer/confirmation_instructions
    def confirmation_instructions
      MyDeviseMailer.confirmation_instructions(User.first, {})
    end

    # hit http://localhost:3000/rails/mailers/devise/mailer/password_change
    def password_change
      MyDeviseMailer.password_change(User.first, {})
    end

    # hit http://localhost:3000/rails/mailers/devise/mailer/reset_password_instructions
    def reset_password_instructions
      MyDeviseMailer.reset_password_instructions(User.first, {})
    end

    # hit http://localhost:3000/rails/mailers/devise/mailer/unlock_instructions
    def unlock_instructions
      MyDeviseMailer.unlock_instructions(User.first, {})
    end
  end
end
