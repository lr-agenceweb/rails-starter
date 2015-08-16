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
    truncate_html(string, length: length, omission: '... ' + (link_to(t('link.read_more'), link)))
  end

  def show_flash
    f = ''
    flash.each do |type, message|
      next if flash[type].nil?
      klass = klass_by_type(type)
      f << content_tag(:div, class: "alert-box #{klass}", data: { alert: '' }, 'tabindex': 0, 'aria-live': 'assertive', role: 'dialogalert') do
        concat(message.html_safe) +
          concat(content_tag(:a, '&times'.html_safe, href: '#', class: 'close', 'tabindex': 0, 'aria-label': 'Close Alert'))
      end
    end
    f.html_safe
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
