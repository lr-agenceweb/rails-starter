# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == CommentsableConcern
  #
  module Commentsable
    extend ActiveSupport::Concern

    included do
      include OptionalModules::CommentHelper

      before_action :set_commentable,
                    only: [:show],
                    if: proc { @comment_module.enabled? }
      before_action :set_comments,
                    only: [:show],
                    if: proc { @comment_module.enabled? && !@commentable.nil? }
      before_action :set_pagination,
                    only: [:show],
                    if: proc { @comment_module.enabled? && !@commentable.nil? }
      before_action :set_comment_setting,
                    only: [:show],
                    if: proc { @comment_module.enabled? }

      def set_commentable
        @commentable = instance_variable_get("@#{controller_name.singularize}")
        @comment = Comment.new
      end

      def set_comments
        @comments = @commentable.comments.validated.by_locale(@language).includes(:user)
      end

      def set_pagination
        @comments = @comments.page params[:page]
      end

      def set_comment_setting
        @comment_setting = CommentSetting.first
        gon.push(emoticons: @comment_setting.emoticons)
      end
    end
  end
end
