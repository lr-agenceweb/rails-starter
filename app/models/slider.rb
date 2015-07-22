# == Schema Information
#
# Table name: sliders
#
#  id          :integer          not null, primary key
#  animate     :string(255)
#  autoplay    :boolean          default(TRUE)
#  timeout     :integer          default(5000)
#  hover_pause :boolean          default(TRUE)
#  loop        :boolean          default(TRUE)
#  navigation  :boolean          default(FALSE)
#  bullet      :boolean          default(FALSE)
#  online      :boolean          default(TRUE)
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sliders_on_category_id  (category_id)
#

#
# == Slider Model
#
class Slider < ActiveRecord::Base
  include Imageable

  has_many :slides, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :slides, reject_if: :all_blank, allow_destroy: true

  belongs_to :category, dependent: :destroy

  delegate :online, to: :slides, prefix: true, allow_nil: true
  delegate :name, to: :category, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }
  scope :by_page, -> (page) { joins(:category).where('categories.name = ?', page) }
end
