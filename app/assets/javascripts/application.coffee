#= require cable

#= require jquery
#= require jquery_ujs
#= require jquery-ui/autocomplete

#= require plugins/foundation

#= require globals/_functions
#= require base/flash
#= require base/button_states

#= require turbolinks
#= require plugins/nprogress

#= require rails.validations
#= require rails.validations.simple_form
#= require rails.validations.simple_form.fix

#= require i18n
#= require i18n/translations
#= require base/i18n_settings

#= require plugins/masonry

#= require plugins/newsletter_user_form

#= require magnific-popup
#= require modules/magnific_popup

#= require vex.combined.min.js
#= require plugins/vex_config

#= require js.cookie
#= require plugins/cookie_ie
#= require plugins/cookie_adult_validation
#= require plugins/cookie_cnil

#= require form_backup
#= require jquery.autosize
#= require jquery.autosize.initializer

#= require plugins/override_rails_confirm
#= require classes/social_share_class

#= require mapbox
#= require plugins/mapbox

#= require fotorama
#= require plugins/fotorama

#= require plugins/fullcalendar

#= require modules/responsive_menu
#= require modules/autocomplete_search
#= require modules/comment

#= require outdatedbrowser/outdatedBrowser
#= require outdated_browser

#= require plugins/emoticonize

#= require mediaelement_rails
#= require mediaelement/mejs-feature-logo.min
#= require plugins/mediaelement

#= require modules/scroll_infinite

#= require plugins/devkit
#= require polyfills/object-fit-images.js

$(document).on 'ready page:load page:restore', ->
  # Object fit polyfill
  objectFitImages('img.polyfill', { watchMQ: true })

  # Save form inputs in LocalStorage
  $('form').formBackup()
  $('form[data-validate]').validate()

  # Display date and time in a friendly way
  friendly_date()
