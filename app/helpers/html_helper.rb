# frozen_string_literal: true

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
    truncate_html(string, length: length, omission: '... ' + link_to(t('link.read_more'), link))
  end

  private

  def klass_by_type(type)
    case type
    when 'success', 'notice'
      return 'success'
    when 'error', 'alert'
      return 'alert'
    else
      ''
    end
  end
end
