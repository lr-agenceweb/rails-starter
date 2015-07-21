# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  name               :string(255)
#  color              :string(255)
#  show_in_menu       :boolean          default(TRUE)
#  show_in_footer     :boolean          default(FALSE)
#  position           :integer
#  optional           :boolean          default(FALSE)
#  optional_module_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_categories_on_optional_module_id  (optional_module_id)
#

#
# == Category Model
#
class Category < ActiveRecord::Base
  include Imageable

  translates :title
  active_admin_translates :title

  acts_as_list

  belongs_to :optional_module
  has_one :slider, dependent: :destroy

  has_one :background, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :background, reject_if: :all_blank, allow_destroy: true

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true


  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true
  delegate :enabled, to: :optional_module, prefix: true, allow_nil: true

  scope :visible_header, -> { where(show_in_menu: true) }
  scope :visible_footer, -> { where(show_in_footer: true) }
  scope :by_position, -> { order(position: :asc) }
  scope :with_allowed_module, -> { eager_load(:optional_module).where('(optional=? AND optional_module_id IS NULL) OR (optional=? AND optional_modules.enabled=?)', false, true, true) }

  def self.models_name
    [:Home, :About, :Contact, :Search, :GuestBook, :Blog]
  end

  def self.models_name_str
    %w( Home About Contact Search GuestBook Blog)
  end

  def self.title_by_category(category)
    Category.find_by(name: category).title
  end
end
