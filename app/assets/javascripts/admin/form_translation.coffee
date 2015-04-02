$ ->
  if $('.available-locales').length
    switch_locale($('.available-locales'))
    slugify()

    $('.button.has_many_add').on 'click', (e) ->
      setTimeout (->
        switch_locale($('.available-locales:last'))
        return
      ), 20

###*
# Function to switch default locale in activeadmin-globalize
###
switch_locale = (element) ->
  english_language = element.find('li:first-child').html()
  french_language = element.find('li:last-child').html()

  element.find('li:first-child').html(french_language)
  element.find('li:last-child').html(english_language)


slugify = ->
  categories = ['home', 'about', 'career', 'photography', 'webdesign', 'print']
  $.each categories, (i, val) ->
    j = 0
    while j < 2
      $("#"+val+"_translations_attributes_"+j+"_title").keyup (e) ->
        title = $(this).val()
        slug = string_to_slug($(this).val())
        $(this).parent().next('li').find('input').val(slug)
      j++


###*
# Function to slugify a string
# @param {string} string to slugify
###
string_to_slug = (str) ->
  str = str.replace(/^\s+|\s+$/g, "") # trim
  str = str.toLowerCase()

  # remove accents, swap ñ for n, etc
  from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;"
  to = "aaaaeeeeiiiioooouuuunc------"
  i = 0
  l = from.length

  while i < l
    str = str.replace(new RegExp(from.charAt(i), "g"), to.charAt(i))
    i++
  # remove invalid chars
  # collapse whitespace and replace by -
  str = str.replace(/[^a-z0-9 -]/g, "").replace(/\s+/g, "-").replace(/-+/g, "-") # collapse dashes
  str