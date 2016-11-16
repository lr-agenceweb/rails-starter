# frozen_string_literal: true

#
# == Slider Model
#
class Slider < ApplicationRecord
  include OptionalModules::Assets::Slideable

  def self.allowed_animations
    %w(crossfade slide dissolve)
  end

  # Alias
  alias_attribute :looper, :loop

  # Models associations
  belongs_to :page

  # Delegates
  delegate :online, to: :slides, prefix: true, allow_nil: true
  delegate :name, to: :page, prefix: true, allow_nil: true

  # Scopes
  scope :online, -> { where(online: true) }
  scope :by_page, ->(page) { joins(:page).where('pages.name = ?', page) }

  # Validation rules
  validates :page, presence: true
  validates :time_to_show, presence: true
  validates :animate,
            presence: true,
            inclusion: { in: allowed_animations }
end

# == Schema Information
#
# Table name: sliders
#
#  id           :integer          not null, primary key
#  animate      :string(255)
#  autoplay     :boolean          default(TRUE)
#  time_to_show :integer          default(5000)
#  hover_pause  :boolean          default(TRUE)
#  loop         :boolean          default(TRUE)
#  navigation   :boolean          default(FALSE)
#  bullet       :boolean          default(FALSE)
#  online       :boolean          default(TRUE)
#  page_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_sliders_on_page_id  (page_id)
#
