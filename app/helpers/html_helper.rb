#
# == HtmlHelper
#
module HtmlHelper
  include TruncateHtmlHelper

  def sanitize_string(string)
    ActionView::Base.full_sanitizer.sanitize(string)
  end

  def sanitize_and_truncate(string, length = 160)
    truncate_html(sanitize_string(string), length: length, separator: '.', escape: true)
  end

  def truncate_read_more(string, link, length = 160)
    truncate(string, length: length, separator: '.', escape: false) do
      content_tag :p do
        link_to t('link.read_more'), link
      end
    end
  end
end
