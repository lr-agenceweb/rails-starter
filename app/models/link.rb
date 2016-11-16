# frozen_string_literal: true

#
# == Link model
#
class Link < ApplicationRecord
  belongs_to :linkable,
             polymorphic: true,
             touch: true

  validates :url,
            allow_blank: true,
            url: true
end

# == Schema Information
#
# Table name: links
#
#  id            :integer          not null, primary key
#  linkable_type :string(255)
#  linkable_id   :integer
#  url           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#
