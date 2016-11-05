#= require foundation.core.js
#= require foundation.abide.js
#= require foundation.accordion.js
#= require foundation.accordionMenu.js
#= require foundation.drilldown.js
#= require foundation.dropdown.js
#= require foundation.dropdownMenu.js
#= require foundation.equalizer.js
#= require foundation.interchange.js
#= require foundation.magellan.js
#= require foundation.offcanvas.js
#= require foundation.orbit.js
#= require foundation.responsiveMenu.js
#= require foundation.responsiveToggle.js
#= require foundation.reveal.js
#= require foundation.slider.js
#= require foundation.sticky.js
#= require foundation.tabs.js
#= require foundation.toggler.js
#= require temporary_workaround/foundation.tooltip.js
#= require foundation.util.box.js
#= require foundation.util.keyboard.js
#= require foundation.util.mediaQuery.js
#= require foundation.util.motion.js
#= require foundation.util.nest.js
#= require foundation.util.timerAndImageLoader.js
#= require foundation.util.touch.js
#= require foundation.util.triggers.js

# UPGRADEME: Use official Tooltip version when 6.3 will be released
$(document).on 'ready page:load page:restore', ->
  $(document).foundation()

  # Workaround Sticky and Turbolinks
  if $('[data-sticky]').length > 0
    $(window).trigger('load.zf.sticky')
