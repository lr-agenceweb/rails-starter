# frozen_string_literal: true

#
# Menu Model
# ============
class Menu < ApplicationRecord
  include Positionable

  # Translations
  translates :title, fallbacks_for_empty_translations: true
  active_admin_translates :title

  has_ancestry

  # Model relations
  has_one :page, dependent: :nullify
  has_one :optional_module, through: :page

  # Delegates
  delegate :name, to: :page, prefix: true, allow_nil: true
  delegate :optional, to: :page, prefix: true, allow_nil: true

  # Scopes
  scope :only_parents, -> { where(ancestry: nil) }
  scope :with_page, -> { joins(:page).where.not('pages.menu_id': nil) }
  scope :visible_header, -> { where(show_in_header: true) }
  scope :visible_footer, -> { where(show_in_footer: true) }
  scope :online, -> { where(online: true) }
  scope :with_allowed_modules, -> { eager_load(:page, :optional_module).where('pages.optional=? OR (pages.optional=? AND optional_modules.enabled=?)', false, true, true) }

  def self.except_current_and_submenus(myself = nil)
    menus = []
    Menu.includes(:translations).only_parents.each do |menu|
      menus << menu if menu != myself
    end
    menus
  end

  def self.visible_header_title
    visible_header.collect { |c| [c.title, c.id] }
  end

  def self.self_or_available(myself = nil)
    menu = []
    Menu.includes(:translations, :page).each do |item|
      menu << item if item.page.nil? || item.try(:page) == myself
    end
    menu
  end
end

# == Schema Information
#
# Table name: menus
#
#  id             :integer          not null, primary key
#  online         :boolean          default(TRUE)
#  show_in_header :boolean          default(TRUE)
#  show_in_footer :boolean          default(FALSE)
#  ancestry       :string(255)
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
