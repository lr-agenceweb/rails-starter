# frozen_string_literal: true

#
# NewsletterUserRole Model
# ==========================
class NewsletterUserRole < ApplicationRecord
  # Translations
  translates :title, fallbacks_for_empty_translations: true
  active_admin_translates :title do
    validates :title, presence: true
  end

  # Model relations
  belongs_to :rollable, polymorphic: true
  has_many :newsletter_users

  def self.allowed_newsletter_user_roles
    %w(subscriber tester)
  end

  # Validation rules
  validates :kind,
            presence: true,
            allow_blank: false,
            inclusion: { in: allowed_newsletter_user_roles }

  def self.newsletter_user_role_dropdown
    includes(:translations).all.map { |nur| [nur.title, nur.id] }
  end
end

# == Schema Information
#
# Table name: newsletter_user_roles
#
#  id            :integer          not null, primary key
#  rollable_type :string(255)
#  rollable_id   :integer
#  kind          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_newsletter_user_roles_on_rollable_type_and_rollable_id  (rollable_type,rollable_id)
#
