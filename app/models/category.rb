# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  name           :string(255)
#  show_in_menu   :boolean          default(TRUE)
#  show_in_footer :boolean          default(FALSE)
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

#
# == Category Model
#
class Category < ActiveRecord::Base
  translates :title
  active_admin_translates :title

  acts_as_list

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true

  scope :visible_header, -> { where(show_in_menu: true) }
  scope :visible_footer, -> { where(show_in_footer: true) }
  scope :by_position, -> { order(position: :asc) }

  def self.models_name
    [:Home, :About, :Contact, :Search, :GuestBook]
  end

  def self.models_name_str
    %w( Home About Contact Search GuestBook)
  end

  def self.title_by_category(category)
    Category.find_by(name: category).title
  end
end
