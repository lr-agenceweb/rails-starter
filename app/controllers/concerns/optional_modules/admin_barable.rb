# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == AdminBarableConcern
  #
  module AdminBarable
    extend ActiveSupport::Concern

    included do
      before_action :admin_bar_enabled?
      before_action :set_comments_count, if: proc { @comment_module.enabled? && @admin_bar_enabled }
      before_action :set_guest_books_count, if: proc { @guest_book_module.enabled? && @admin_bar_enabled }
      before_action :set_module_settings, if: proc { @admin_bar_enabled }

      private

      def admin_bar_enabled?
        @admin_bar_enabled = current_user_and_administrator?(current_user) && @setting.show_admin_bar? ? true : false
      end

      def set_comments_count
        @comments_to_validate_count = Comment.select(:id).to_validate.count
        @comments_signalled_count = Comment.select(:id).signalled.count
      end

      def set_guest_books_count
        @guest_books_to_validate_count = GuestBook.select(:id).to_validate.count
      end

      def set_module_settings
        @comment_setting_admin_bar = CommentSetting.first
        @guest_book_setting_admin_bar = GuestBookSetting.first
      end
    end
  end
end
