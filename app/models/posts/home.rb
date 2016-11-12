# frozen_string_literal: true
# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  slug            :string(255)
#  show_as_gallery :boolean          default(FALSE)
#  allow_comments  :boolean          default(TRUE)
#  online          :boolean          default(TRUE)
#  position        :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_posts_on_slug     (slug) UNIQUE
#  index_posts_on_user_id  (user_id)
#

#
# == Home Model
#
class Home < Post
end
