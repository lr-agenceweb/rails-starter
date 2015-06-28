# == Schema Information
#
# Table name: guest_books
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  content    :text(65535)
#  lang       :string(255)
#  validated  :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == GuestBook model
#
class GuestBook < ActiveRecord::Base
  include Scopable

  validates :username,
            presence: true

  validates :content,
            presence: true

  validates :lang,
            presence: true,
            inclusion: %w( fr en )

  default_scope { order('created_at DESC') }

  attr_accessor :nickname
  paginates_per 3
end
