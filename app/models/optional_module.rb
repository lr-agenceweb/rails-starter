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
  scope :by_name, -> (name) { where(name: name) }

  def self.list
    %w( Newsletter GuestBook Search RSS Comment )
  end
end
