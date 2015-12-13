# == Schema Information
#
# Table name: mailing_settings
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == MailingSetting Model
#
class MailingSetting < ActiveRecord::Base
  validates :email,
            allow_blank: true,
            email_format: true
end
