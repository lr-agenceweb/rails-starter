# frozen_string_literal: true

# == Schema Information
#
# Table name: guest_books
#
#  id         :integer          not null, primary key
#  username   :string(255)      not null
#  email      :string(255)      not null
#  content    :text(65535)      not null
#  lang       :string(255)      not null
#  validated  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == GuestBook model
#
class GuestBook < ApplicationRecord
  include Scopable
  include Validatable

  attr_accessor :nickname
  alias_attribute :comment, :content

  validates :username,
            presence: true,
            allow_blank: false
  validates :email,
            presence: true,
            allow_blank: false,
            email_format: true

  validates :content, presence: true
  validates :lang,
            presence: true,
            allow_blank: false,
            inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :nickname,
            absence: true

  default_scope { order('created_at DESC') }

  paginates_per 3
end
