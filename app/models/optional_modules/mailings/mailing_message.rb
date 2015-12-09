# == Schema Information
#
# Table name: mailing_messages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text(65535)
#  sent_at    :datetime
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == MailingMessage Model
#
class MailingMessage < ActiveRecord::Base
  include Tokenable
  include Mailable

  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content

  has_many :mailing_users, through: :mailing_message_users
  has_many :mailing_message_users, dependent: :destroy
end
