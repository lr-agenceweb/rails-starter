# frozen_string_literal: true

#
# GuestBookSetting Model
# ========================
class GuestBookSetting < ApplicationRecord
  include MaxRowable
end

# == Schema Information
#
# Table name: guest_book_settings
#
#  id              :integer          not null, primary key
#  should_validate :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
