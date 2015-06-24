# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  title            :string(50)       default("")
#  username         :string(255)
#  email            :string(255)
#  comment          :text(65535)
#  lang             :string(255)
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  role             :string(255)      default("comments")
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_comments_on_commentable_id    (commentable_id)
#  index_comments_on_commentable_type  (commentable_type)
#  index_comments_on_user_id           (user_id)
#

#
# == Comment Model
#
class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  delegate :username, :email, to: :user, prefix: true, allow_nil: true

  validates :username, presence: true, unless: proc { |c| c.user_id }
  validates :email,    presence: true, email_format: {}, unless: proc { |c| c.user_id }
  validates :comment,  presence: true
  validates :lang,
            presence: true,
            inclusion: %w( fr en )

  scope :by_user, -> (user_id) { where(user_id: user_id) }
  scope :by_locale, -> (locale) { where(lang: locale) }

  attr_accessor :nickname
  default_scope { order('created_at DESC') }
  paginates_per 15
end
