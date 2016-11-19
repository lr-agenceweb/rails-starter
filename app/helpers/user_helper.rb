# frozen_string_literal: true

#
# == UserHelper
#
module UserHelper
  def current_user_and_administrator?(user = current_user)
    user && user.admin_or_super?
  end
end
