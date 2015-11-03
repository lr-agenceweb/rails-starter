$(document).on 'ready page:load page:restore', ->
  if gon.adult_validation is true and Cookies.get('adult') is undefined
    vex.dialog.confirm
      message: "<h3>#{gon.adult_not_validated_popup_title}</h3> #{gon.adult_not_validated_popup_content}"
      callback: (value) ->
        window.location.href = gon.adult_not_validated_popup_redirect_link if value is false
        Cookies.set('adult', 'validated') if value is true
