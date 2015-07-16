# == Schema Information
#
# Table name: optional_modules
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  enabled    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == OptionalModule Model
#
class OptionalModule < ActiveRecord::Base
  has_one :category, dependent: :destroy

  def self.list
    %w( Newsletter GuestBook Search RSS Comment Blog )
  end

  def self.by_name(name)
    find_by(name: name)
  end
end
