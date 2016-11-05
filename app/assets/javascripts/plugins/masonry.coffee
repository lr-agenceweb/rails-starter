#= require masonry/masonry.imagesLoaded.min.js
#= require masonry/masonry.pkgd.min.js

$(document).on 'ready page:load page:restore', ->
  reload_masonry(true)
