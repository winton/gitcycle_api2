#= require lib/magnific
$ ->
  $('.open-popup-link').magnificPopup(
    type: 'inline'
    midClick: true
  )

window.openBacktrace = (id) ->
  $.magnificPopup.open(
    items: src: '#backtrace-' + id
    type: 'inline'
  )