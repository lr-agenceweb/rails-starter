# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  title            :string(50)       default("")
#  username         :string(255)
#  email            :string(255)
#  comment          :text(65535)
#  token            :string(255)
#  lang             :string(255)
#  validated        :boolean          default(FALSE)
#  signalled        :boolean          default(FALSE)
#  ancestry         :string(255)
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  role             :string(255)      default("comments")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_ancestry          (ancestry)
#  index_comments_on_commentable_id    (commentable_id)
#  index_comments_on_commentable_type  (commentable_type)
#  index_comments_on_user_id           (user_id)
#

#
# == Comment Model
#
class Comment < ActiveRecord::Base
  include Tokenable
  include Scopable
  include Validatable

  attr_accessor :subject, :nickname, :children_ids
  alias_attribute :content, :comment

  before_destroy :set_descendants

  has_ancestry

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :username,
            allow_blank: true,
            presence: true
  validates :email,
            allow_blank: true,
            presence: true,
            email_format: true
  validates :comment,
            presence: true
  validates :lang,
            presence: true,
            inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :nickname,
            absence: true

  default_scope { order('created_at DESC') }
  scope :by_user, -> (user_id) { where(user_id: user_id) }
  scope :signalled, -> { where(signalled: true) }
  scope :only_blogs, -> { where(commentable_type: 'Blog') }

  paginates_per 15

  delegate :username, :email, to: :user, prefix: true, allow_nil: true

  private

  def set_descendants
    self.children_ids = has_children? ? descendant_ids : []
    children_ids
  end
end
