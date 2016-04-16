# frozen_string_literal: true
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

#
# == MailingMessageUser Model
#
class MailingMessageUser < ActiveRecord::Base
  belongs_to :mailing_user
  belongs_to :mailing_message
end
