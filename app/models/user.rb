# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  username               :string(255)
#  slug                   :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  role_id                :integer          default(3), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  avatar_file_name       :string(255)
#  retina_dimensions      :text(65535)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  account_active         :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_slug                  (slug)
#

#
# == User Model
#
class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]

  # Concerns
  include Users::RegisterActivable
  include Assets::Avatarable
  include OptionalModules::Omniauthable

  # Helpers
  include AssetsHelper

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy
  has_many :blogs, dependent: :destroy
  belongs_to :role
  accepts_nested_attributes_for :role, reject_if: :all_blank

  delegate :name, to: :role, prefix: true, allow_nil: true

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false,
              scope: :provider
            },
            if: proc { |u| u.new_record? || u.changed? }

  validates :email,
            presence: { message: 'Ne doit pas être vide' },
            email_format: true,
            uniqueness: {
              case_sensitive: false,
              scope: :provider
            }

  scope :except_super_administrator, -> { where.not(role_id: 1) }

  # define has_role? methods
  %w(super_administrator administrator subscriber).each do |role|
    define_method(:"#{role}?") do
      role_name == role
    end
  end

  def should_generate_new_friendly_id?
    username_changed? || super
  end

  # Access current_user in model
  def self.current_user
    Thread.current[:current_user]
  end

  def self.current_user=(user)
    Thread.current[:current_user] = user
  end
end
