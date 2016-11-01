# frozen_string_literal: true
datetime_picker_input = Formtastic::Inputs::StringInput::DateTimePickerInput

# This is for front-end (JavaScript)
datetime_picker_input.default_datetime_picker_options = {
  format: 'Y-m-d H:i',
  defaultTime: '12:00',
  inline: false,
  timepicker: false,
  lang: 'fr',
  scrollMonth: false,
  scrollTime: false,
  dayOfWeekStart: 1,
  minDate: 0
}

# This is for backend (Ruby)
datetime_picker_input.format = '%Y-%m-%d %H:%M'
