#
# == CommentableConcern
#
module Commentable
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:show]
    before_action :set_comment_setting, only: [:show]

    def set_commentable
      @commentable = instance_variable_get("@#{controller_name.singularize}")
      @full_comments = @commentable.comments.validated.by_locale(@language).includes(:user)
      @comments = @full_comments.page params[:page]
      @comments = CommentDecorator.decorate_collection(@comments)
      @comment = Comment.new
    end

    def set_comment_setting
      @comment_setting = CommentSetting.first
    end
  end
end
