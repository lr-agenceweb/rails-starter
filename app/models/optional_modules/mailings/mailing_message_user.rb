# frozen_string_literal: true

#
# == MailingMessageUser Model
#
class MailingMessageUser < ApplicationRecord
  belongs_to :mailing_user
  belongs_to :mailing_message
end

# == Schema Information
#
# Table name: mailing_message_users
#
#  id                 :integer          not null, primary key
#  mailing_user_id    :integer
#  mailing_message_id :integer
#
# Indexes
#
#  index_mailing_message_users_on_mailing_message_id  (mailing_message_id)
#  index_mailing_message_users_on_mailing_user_id     (mailing_user_id)
#
