$ ->
  if $('.available-locales, form.slider, form.newsletter_setting').length
    switch_locale($('.available-locales'))
    # slugify()


    $('form.slider .button.has_many_add, form.newsletter_setting .button.has_many_add').on 'click', (e) ->
      setTimeout (->
        switch_locale($('.has_many_container.slides, .has_many_container.newsletter_user_roles').find('.inputs.has_many_fields:last').find('.available-locales:last'))
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
  pages = ['home', 'about', 'content', 'blog', 'event', 'blog_category']
  $.each pages, (i, val) ->
    column = if val == 'blog_category' then 'name' else 'title'
    j = 0
    while j < 2
      $("#"+val+"_translations_attributes_"+j+"_" + column).keyup (e) ->
        title = $(this).val()
        slug = string_to_slug($(this).val())
        $(this).parent().next('li').find('input').val(slug)
      j++


###*
# Function to slugify a string
# @param {string} string to slugify
###
string_to_slug = (str) ->

  # remove accents, swap ñ for n, etc
  from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;'"
  to = "aaaaeeeeiiiioooouuuunc-------"
  i = 0
  l = from.length

  while i < l
    str = str.replace(new RegExp(from.charAt(i), "g"), to.charAt(i))
    i++

  str = str.toString().toLowerCase()
      .replace(/\s+/g, '-')           # Replace spaces with -
      .replace(/[^\w\-]+/g, '')       # Remove all non-word chars
      .replace(/\-\-+/g, '-')         # Replace multiple - with single -
      .replace(/^-+/, '')             # Trim - from start of text
      .replace(/-+$/, '');            # Trim - from end of text

  str
