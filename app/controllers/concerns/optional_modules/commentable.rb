#
# == CommentableConcern
#
module Commentable
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:show]

    def set_commentable
      @commentable = instance_variable_get("@#{controller_name.singularize}")
      @comments = @commentable.comments.validated.by_locale(@language).includes(:user).page params[:page]
      @comments = CommentDecorator.decorate_collection(@comments)
      @comment = Comment.new
    end
  end
end
