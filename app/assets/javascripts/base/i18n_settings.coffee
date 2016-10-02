$(document).on 'ready page:load page:restore', ->
  I18n.defaultLocale = gon.language
  I18n.locale = gon.language
  I18n.fallbacks = true
