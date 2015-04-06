#
# == User Model
#
class User < ActiveRecord::Base
  belongs_to :role

  retina!
  has_attached_file :avatar,
                    path: ':rails_root/public/system/avatar/:id/:style/:filename',
                    url:  '/system/avatar/:id/:style/:filename',
                    styles: {
                      large: '512x512#',
                      medium:  '256x256#',
                      small:  '128x128#'
                    },
                    retina: { quality: 70 },
                    default_url: '/system/default/:style/missing.png'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  delegate :name, to: :role, prefix: true, allow_nil: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def super_administrator?
    role_name == 'super_administrator'
  end

  def administrator?
    role_name == 'administrator'
  end

  def subscriber?
    role_name == 'subscriber'
  end
end
