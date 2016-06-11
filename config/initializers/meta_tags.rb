# frozen_string_literal: true

# Module contains helpers that normalize text meta tag values.
module MetaTags
  module TextNormalizer
    def self.strip_tags(string)
      ERB::Util.html_escape helpers.sanitize(string)
    end
  end
end
