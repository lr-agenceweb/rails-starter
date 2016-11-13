# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string(255)
#  commentable_id   :integer
#  username         :string(255)
#  email            :string(255)
#  comment          :text(65535)
#  token            :string(255)
#  lang             :string(255)
#  validated        :boolean          default(FALSE)
#  signalled        :boolean          default(FALSE)
#  ancestry         :string(255)
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_ancestry                             (ancestry)
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#

#
# == Comment Model
#
class Comment < ActiveRecord::Base
  include Core::Userable
  include Tokenable
  include Scopable
  include Validatable

  attr_accessor :nickname, :children_ids
  alias_attribute :content, :comment

  MAX_COMMENTS_DEPTH ||= 2
  I18N_ERRORS_SCOPE ||= 'activerecord.errors.models.comment.attributes'

  has_ancestry
  paginates_per 15

  # Callbacks
  before_destroy :set_descendants

  # Model associations
  belongs_to :commentable, polymorphic: true, touch: true

  # Validation rules
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
  validate :max_depth, if: :strict_max_depth?

  # Scopes
  default_scope { order('created_at DESC') }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :signalled, -> { where(signalled: true) }
  scope :only_blogs, -> { where(commentable_type: 'Blog') }

  # Delegate
  delegate :title, to: :commentable, prefix: true, allow_nil: true

  def max_depth
    errors.add(:parent_id, I18n.t('max_depth', scope: I18N_ERRORS_SCOPE))
  end

  def max_depth?(op = '>=')
    depth.send(op, MAX_COMMENTS_DEPTH)
  end

  def strict_max_depth?
    max_depth?('>')
  end

  private

  def set_descendants
    self.children_ids = has_children? ? descendant_ids : []
    children_ids
  end
end
