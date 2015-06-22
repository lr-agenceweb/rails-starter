# == Schema Information
#
# Table name: guest_books
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  content    :text(65535)
#  lang       :string(255)
#  online     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == GuestBook model
#
class GuestBook < ActiveRecord::Base
end
