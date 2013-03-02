//= require jquery
//= require lib/underscore
//= require lib/backbone

window.gitcycle = events: _.extend({}, Backbone.Events)

$ ->
  login  = $('.login').hide()
  logout = $('.logout').hide()

  $.get "/session.json", (data) ->
    if data
      $('.logout').show()
      $('.nav-collapse .nav').show()
      gitcycle.session = data
      gitcycle.events.trigger("session", data)
    else
      $('.login').show()
    $('.nav-collapse .pull-right').show()