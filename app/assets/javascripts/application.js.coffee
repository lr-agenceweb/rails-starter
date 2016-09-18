#= require jquery
#= require jquery_ujs
#= require jquery-ui/autocomplete

#= require foundation
#= require plugins/foundation_init

#= require globals/_functions
#= require base/flash

#= require turbolinks
#= require plugins/nprogress

#= require rails.validations
#= require rails.validations.simple_form
#= require rails.validations.simple_form.fix

#= require i18n
#= require i18n/translations

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

#= require moment
#= require moment/en-gb
#= require fullcalendar
#= require fullcalendar/lang/fr
#= require plugins/fullcalendar

#= require modules/responsive_menu
#= require modules/autocomplete_search

#= require outdatedbrowser/outdatedBrowser
#= require outdated_browser

#= require mediaelement_rails
#= require mediaelement/mejs-feature-logo.min
#= require plugins/mediaelement

#= require modules/scroll_infinite
#= require modules/sticky_sidebar

#= require plugins/devkit

$(document).on 'ready page:load page:restore', ->
  # Save form inputs in LocalStorage
  $('form').formBackup()
  $('form[data-validate]').validate()

  friendly_date()
  comment_reply_loader()

comment_reply_loader = ->
  $('.comment-reply').on 'click', (e) ->
    $(this).find('.spinner').removeClass('hide')
