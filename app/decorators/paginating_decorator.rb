# frozen_string_literal: true
#
# == PaginatingDecorator
#
class PaginatingDecorator < Draper::CollectionDecorator
  include Draper::LazyHelpers
  delegate :current_page, :total_pages, :limit_value, :model_name, :total_count, :next_page
end
