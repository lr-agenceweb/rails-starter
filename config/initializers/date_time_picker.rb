# frozen_string_literal: true
datetime_picker_input = Formtastic::Inputs::StringInput::DateTimePickerInput

# This is for front-end (JavaScript)
datetime_picker_input.default_datetime_picker_options = {
  # Core
  lang: 'fr',
  inline: false,
  scrollMonth: false,
  scrollTime: false,

  # Date
  minDate: 0,
  dayOfWeekStart: 1,
  format: 'Y-m-d H:i',

  # Time
  timepicker: true,
  defaultTime: '10:00',
  allowTimes: [*Event::EVENT_START..Event::EVENT_END].map { |i| "#{i}:00" }
}

# This is for backend (Ruby)
datetime_picker_input.format = '%Y-%m-%d %H:%M'
