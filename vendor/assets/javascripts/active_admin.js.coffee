#= require active_admin/base
#= require activeadmin-sortable
#= require jquery-ui
#= require jquery.datetimepicker
#= require plugins/datetimepicker
#= require chosen-jquery
#= require admin/form_translation
#= require admin/froala_editor
#= require admin/chosen
#= require admin/newsletters_preview
#= require admin/mailings
#= require admin/counter_letters
#= require gmaps.js
#= require globals/_functions
#= require mapbox
#= require plugins/mapbox
#= require admin/map
#= require vex.combined.min.js
#= require plugins/vex_config
#= require plugins/override_rails_confirm
#= require i18n
#= require i18n/translations
#= require jquery.minicolors
#= require admin/minicolors
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
