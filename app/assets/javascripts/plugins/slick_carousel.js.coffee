$(document).on 'ready page:load page:restore', ->
  if $('.slick-carousel').length

    $('.slick-carousel').slick
      slidesToShow: 1
      dots: gon.bullet
      autoplay: gon.autoplay
      infinite: gon.loop
      fade: if gon.animate == 'fade' then true else false
      pauseOnHover: gon.hover_pause
      pauseOnDotsHover: gon.hover_pause
      speed: gon.timeout
      autoplaySpeed: gon.timeout
      arrows : gon.navigation
      centerMode: true
      # lazyLoad: true
