#
# == ApplicationHelper
#
module ApplicationHelper
  include TruncateHtmlHelper

  def current_year
    Time.zone.now.year
  end

  def sanitize_string(string)
    ActionView::Base.full_sanitizer.sanitize(string)
  end

  def sanitize_and_truncate(string, length = 160)
    truncate_html(sanitize_string(string), length: length, separator: '.', escape: true)
  end
end
