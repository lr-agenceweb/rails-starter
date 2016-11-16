# frozen_string_literal: true

#
# == MailingSetting Model
#
class MailingSetting < ApplicationRecord
  include MaxRowable

  translates :signature, :unsubscribe_title, :unsubscribe_content,
             fallbacks_for_empty_translations: true
  active_admin_translates :signature, :unsubscribe_title, :unsubscribe_content,
                          fallbacks_for_empty_translations: true

  validates :email,
            allow_blank: true,
            email_format: true
end

# == Schema Information
#
# Table name: mailing_settings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
