#
# == UserHelper
#
module UserHelper
  def current_user_and_administrator?
    current_user && (current_user.administrator? || current_user.super_administrator?)
  end
end
