#= require outdatedbrowser/outdatedBrowser

$(document).on 'ready page:load page:restore', ->
  if Cookies.get('cookie-ie') is undefined
    outdatedBrowser
      bgColor: '#f25648'
      color: '#ffffff'
      lowerThan: 'transform'
      languagePath: ''
