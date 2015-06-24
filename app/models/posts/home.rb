# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  title      :string(255)
#  slug       :string(255)
#  content    :text(65535)
#  online     :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
