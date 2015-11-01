###
## Easter Egg ##
###

easter_egg = new EasterEgg()

k = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]
n = 0

$(document).keydown (e) ->
  if e.keyCode == k[n++] && easter_egg.get_konami() is false
    if n == k.length
      easter_egg.enjoy_easter_egg()
      easter_egg.set_konami(true)
      n = 0
      return
  else
    n = 0
  return
