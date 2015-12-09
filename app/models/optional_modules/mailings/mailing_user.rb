# == Schema Information
#
# Table name: mailing_users
#
#  id         :integer          not null, primary key
#  fullname   :string(255)
#  email      :string(255)
#  token      :string(255)
#  lang       :string(255)
#  archive    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == MailingUser Model
#
class MailingUser < ActiveRecord::Base
end
