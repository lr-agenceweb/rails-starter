#= require active_admin/base
#= require activeadmin_addons/all
#= require activeadmin-sortable

#= require jquery-ui

#= require jquery.datetimepicker
#= require plugins/datetimepicker

#= require modules/password_strength

#= require globals/_functions
#= require plugins/override_rails_confirm

#= require admin/form_translation
#= require admin/froala_editor

#= require admin/newsletters_preview
#= require admin/omniauth_actions
#= require admin/mailings
#= require admin/counter_letters

#= require gmaps.js
#= require mapbox
#= require plugins/mapbox
#= require admin/map

#= require vex.combined.min.js
#= require plugins/vex_config

#= require i18n
#= require i18n/translations

#= require fotorama

$ ->
  if $('#newsletter_setting_send_welcome_email').length
    $this = $('#newsletter_setting_send_welcome_email')
    $('#newsletter_config_form').hide() unless $this.is(':checked')

    $this.on 'click', (e) ->
      if $this.is(':checked')
        $('#newsletter_config_form').slideDown()
      else
        $('#newsletter_config_form').slideUp()


  $('.has_many_delete.boolean input').on 'click', ->
    $(this).parents('.has_many_delete.boolean').siblings().slideToggle()

  # VideoPlatform title and description
  if $('#video_platform_native_informations_input input').length
    $('#video_platform_native_informations_input input').on 'click', ->
      $this = $(this)
      if $this.is(':checked')
        $this.parents('li.input.boolean').next('div').slideUp()
      else
        $this.parents('li.input.boolean').next('div').slideDown()

    $('.activeadmin-translations').slideUp() if $('#video_platform_native_informations_input input').is(':checked')


  # Spinner loader on create or update resource
  $('form input[type=submit]').on 'click', (e) ->
    $('ol li#spinner').remove()
    $(this).parents('ol').append("<li id='spinner' style='margin-left: 10px'><img src='https://media.giphy.com/media/10kTz4r3ishQwU/giphy.gif' alt='loader' height='34' /></li>")

  # CommentSetting :: hide send_email if should_signal is not checked
  if $('#comment_setting_should_signal_input').length
    $this = $('#comment_setting_should_signal_input').find('input')
    $nextLi = $this.parent().parent().next()
    $nextLi.hide() unless $this.is(':checked')

    $this.on 'click', (e) ->
      if $this.is(':checked') then $nextLi.slideDown() else $nextLi.slideUp()
