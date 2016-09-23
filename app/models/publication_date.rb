# frozen_string_literal: true

# == Schema Information
#
# Table name: publication_dates
#
#  id                  :integer          not null, primary key
#  publishable_id      :integer
#  publishable_type    :string(255)
#  published_later     :boolean          default(FALSE)
#  expired_prematurely :boolean          default(FALSE)
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_publication_dates_on_publishable_type_and_publishable_id  (publishable_type,publishable_id)
#

#
# == PublicationDate Model
#
class PublicationDate < ActiveRecord::Base
  belongs_to :publishable, polymorphic: true, touch: true
end
