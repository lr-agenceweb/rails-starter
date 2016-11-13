# frozen_string_literal: true

# Other preset values are [:mvim, :macvim, :textmate, :txmt, :tm, :sublime, :subl, :st]
BetterErrors.editor = 'atm://open?url=file://%{file}&line=%{line}' if defined?(BetterErrors)
