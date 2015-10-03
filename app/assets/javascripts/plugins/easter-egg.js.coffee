$(document).on 'ready page:load page:restore', ->
  easter_egg = new Konami ->
    image = '<div class="easter-egg">
      <figure>
        <img src="/favicon.ico" alt="easter egg" />
        <figcaption>Happy Easter Egg !</figcaption>
      </figure>
    </div>'
    $('body').append($(image)).fadeIn()
    setTimeout (->
      $('.easter-egg').fadeOut ->
        $('.easter-egg').remove()
      return
    ), 2500
