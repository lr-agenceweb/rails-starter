# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == Comment Helper
  #
  module CommentHelper
    def nested_messages(messages)
      messages.map do |message, sub_messages|
        render(message.decorate) + content_tag(:div, nested_messages(sub_messages), class: 'nested_messages')
      end.join.html_safe
    end
  end
end
