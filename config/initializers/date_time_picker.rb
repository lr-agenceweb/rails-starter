datetime_picker_input = Formtastic::Inputs::StringInput::DateTimePickerInput

# This if for front-end javascript side
datetime_picker_input.default_datetime_picker_options = {
  format: 'Y-m-d H:i:s',
  defaultTime: '12:00',
  inline: true,
  timepicker: true,
  lang: 'fr',
  scrollMonth: false,
  scrollTime: false,
  dayOfWeekStart: 1
}

# This if for backend (Ruby)
datetime_picker_input.format = '%Y-%m-%d %H:%i:%s'
