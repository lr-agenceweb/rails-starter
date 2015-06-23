# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  slug                   :string(255)
#  email                  :string(255)      default(""), not null
#  avatar_updated_at      :datetime
#  avatar_file_size       :integer
#  avatar_content_type    :string(255)
#  avatar_file_name       :string(255)
#  retina_dimensions      :text(65535)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  role_id                :integer          default(4), not null
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#

#
# == User Model
#
class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]

  retina!
  has_attached_file :avatar,
                    path: ':rails_root/public/system/avatar/:id/:style-:filename',
                    url:  '/system/avatar/:id/:style-:filename',
                    styles: {
                      large:  '512x512#',
                      medium: '256x256#',
                      small:  '128x128#',
                      thumb:  '64x64#'
                    },
                    retina: { quality: 70 },
                    default_url: '/system/default/:style-missing.png'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  belongs_to :role
  delegate :name, to: :role, prefix: true, allow_nil: true
  accepts_nested_attributes_for :role, reject_if: :all_blank

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true
  validates :email, presence: true, email_format: {}

  def super_administrator?
    role_name == 'super_administrator'
  end

  def administrator?
    role_name == 'administrator'
  end

  def subscriber?
    role_name == 'subscriber'
  end

  def should_generate_new_friendly_id?
    username_changed? || super
  end

  # TODO: make a test for this method
  def avatar?
    !avatar_file_name.nil?
  end
end
