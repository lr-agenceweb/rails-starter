###!
# jQuery Sticky Footer 1.1
# Corey Snyder
# http://tangerineindustries.com
#
# Released under the MIT license
#
# Copyright 2013 Corey Snyder.
#
# Date: Thu Jan 22 2013 13:34:00 GMT-0630 (Eastern Daylight Time)
# Modification for jquery 1.9+ Tue May 7 2013
# Modification for non-jquery, removed all, now classic JS Wed Jun 12 2013
###

checkForDOMChange = ->
  stickyFooter()
  return

getCSS = (element, property) ->
  elem = document.getElementsByTagName(element)[0]
  css = null
  if elem.currentStyle
    css = elem.currentStyle[property]
  else if window.getComputedStyle
    css = document.defaultView.getComputedStyle(elem, null).getPropertyValue(property)
  css

stickyFooter = ->
  if document.getElementsByTagName('footer')[0].getAttribute('style') != null
    document.getElementsByTagName('footer')[0].removeAttribute 'style'
  if window.innerHeight != document.body.offsetHeight
    offset = window.innerHeight - (document.body.offsetHeight)
    current = getCSS('footer', 'margin-top')
    if isNaN(current) == true
      document.getElementsByTagName('footer')[0].setAttribute 'style', 'margin-top:0px;'
      current = 0
    else
      current = parseInt(current)
    if current + offset > parseInt(getCSS('footer', 'margin-top'))
      document.getElementsByTagName('footer')[0].setAttribute 'style', 'margin-top:' + current + offset + 'px;'
  return

window.onload = ->
  # stickyFooter()
  #you can either uncomment and allow the setInterval to auto correct the footer
  #or call stickyFooter() if you have major DOM changes
  setInterval(checkForDOMChange, 1000)
  return

window.onresize = ->
  stickyFooter()
  return
