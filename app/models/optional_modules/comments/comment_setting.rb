# frozen_string_literal: true
# == Schema Information
#
# Table name: comment_settings
#
#  id              :integer          not null, primary key
#  should_signal   :boolean          default(TRUE)
#  send_email      :boolean          default(FALSE)
#  should_validate :boolean          default(TRUE)
#  allow_reply     :boolean          default(TRUE)
#  emoticons       :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

#
# == CommentSetting Model
#
class CommentSetting < ApplicationRecord
  include MaxRowable
end
