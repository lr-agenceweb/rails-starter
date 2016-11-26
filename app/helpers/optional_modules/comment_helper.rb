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
      html = []
      messages.map do |message, sub_messages|
        html << render(message.decorate) + content_tag(:div, nested_messages(sub_messages), class: 'nested_messages')
      end
      safe_join [html]
    end
  end
end
