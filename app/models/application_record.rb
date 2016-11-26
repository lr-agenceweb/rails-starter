# frozen_string_literal: true

#
# ApplicationRecord Model
# =========================
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  #
  # Booleans
  # ==========
  def title?
    try(:title) && title.present?
  end

  def content?
    content.present?
  end

  def description?
    description.present?
  end

  def location?
    location.present?
  end
end
