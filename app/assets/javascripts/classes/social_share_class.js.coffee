window.SocialShareClass =
  openUrl: (url, popup) ->
    if popup == 'true'
      window.open(url,'popup','height=500,width=500')
    else
      window.open(url)
      false

  share: (el) ->
    site = $(el).data('site')
    $parent = if $(el).parent().is 'span' then $(el).parent().parent() else $(el).parent()
    title = encodeURIComponent($parent.data('title') || '')
    img = encodeURIComponent($parent.data('img') || '')
    url = encodeURIComponent($parent.data('url') || '')
    via = encodeURIComponent($parent.data('via') || '')
    popup = encodeURIComponent($parent.data('popup') || 'false')

    if url.length == 0
      url = encodeURIComponent(location.href)
    switch site
      when 'email'
        location.href = "mailto:?to=&subject=#{title}&body=#{url}"
      when 'twitter'
        via_str = if via.length > 0 then "&via=#{via}" else ''
        SocialShareClass.openUrl("https://twitter.com/intent/tweet?url=#{url}&text=#{title}#{via_str}", popup)
      when 'facebook'
        SocialShareClass.openUrl("http://www.facebook.com/sharer.php?u=#{url}", popup)
      when 'google+'
        SocialShareClass.openUrl("https://plus.google.com/share?url=#{url}", popup)
    false