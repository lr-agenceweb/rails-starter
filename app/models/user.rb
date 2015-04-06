#
# == User Model
#
class User < ActiveRecord::Base
  belongs_to :role
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
