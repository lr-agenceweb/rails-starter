# frozen_string_literal: true

#
# == MailingMessage Model
#
class MailingMessage < ApplicationRecord
  include Tokenable
  include Mailable
  include OptionalModules::Assets::Imageable

  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content

  attr_accessor :should_redirect
  before_save :redirect_to_form?,
              if: proc { |r| r.picture.try(:new_record?) || r.picture.try(:changed?) }
  after_save :redirect_to_form?,
             if: proc { |r| r.picture.try(:destroyed?) }

  has_many :mailing_users, through: :mailing_message_users
  has_many :mailing_message_users, dependent: :destroy

  private

  def redirect_to_form?
    self.should_redirect = true
  end
end

# == Schema Information
#
# Table name: mailing_messages
#
#  id             :integer          not null, primary key
#  show_signature :boolean          default(TRUE)
#  sent_at        :datetime
#  token          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
