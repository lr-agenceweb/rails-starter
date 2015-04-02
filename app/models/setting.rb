#
# == Setting Model
#
class Setting < ActiveRecord::Base
  translates :title, :subtitle, fallbacks_for_empty_translations: true
  active_admin_translates :title, :subtitle do
    validates_presence_of :title
  end

  validates :name,     presence: true
  validates :address,  presence: true
  validates :city,     presence: true
  validates :postcode, presence: true, numericality: { only_integer: true }
  validates :email,    presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
