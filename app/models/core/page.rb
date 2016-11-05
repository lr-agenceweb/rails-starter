# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  color              :string(255)
#  optional           :boolean          default(FALSE)
#  optional_module_id :integer
#  menu_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_pages_on_menu_id             (menu_id)
#  index_pages_on_optional_module_id  (optional_module_id)
#

#
# == Page Model
#
class Page < ActiveRecord::Base
  include Core::Headingable
  include Core::Referenceable
  include OptionalModules::Assets::Backgroundable
  include OptionalModules::Assets::VideoUploadable

  # Model relations
  belongs_to :optional_module
  belongs_to :menu
  has_one :slider, dependent: :destroy

  # Delegate
  delegate :enabled, to: :optional_module, prefix: true, allow_nil: true
  delegate :title, :position, :online, to: :menu, prefix: true, allow_nil: true

  # Scopes
  scope :with_allowed_module, -> { eager_load(:optional_module).where('(optional=? AND optional_module_id IS NULL) OR (optional=? AND optional_modules.enabled=?)', false, true, true) }

  def self.title_by_page(page)
    Page.includes(menu: [:translations]).find_by(name: page).menu_title
  end

  def self.handle_pages_for_background(current_background)
    pages = Page.except_already_background(current_background.attachable)
    pages.collect { |c| [c.menu_title, c.id] }
  end

  def slider?
    !slider.nil?
  end

  def self.except_already_background(myself = nil)
    pages = []
    Page.includes(:background).with_allowed_module.each do |page|
      pages << page if page.background.nil? || page == myself
    end
    pages
  end

  def self.except_already_slider(myself = nil)
    pages = []
    Page.includes(:slider).with_allowed_module.each do |page|
      pages << page if page.slider.nil? || page == myself
    end
    pages
  end

  # validates :menu_id,
  #           presence: true,
  #           allow_blank: false,
  #           inclusion: { in: Menu.self_or_available(id).map { |menu| [menu.title, menu.id] } }
end
