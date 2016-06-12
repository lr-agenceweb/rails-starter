# frozen_string_literal: true

#
# == MetaTags module
#
module MetaTags
  #
  # == Module contains helpers that normalize text meta tag values.
  #
  module TextNormalizer
    def self.strip_tags(string)
      ERB::Util.html_escape helpers.sanitize(string)
    end
  end
end
