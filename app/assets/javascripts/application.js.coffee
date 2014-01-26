#= require jquery
#= require lib/underscore
#= require lib/backbone
#= require bootstrap

window.gitcycle = events: _.extend({}, Backbone.Events)

$ ->
  login  = $('.login').hide()
  logout = $('.logout').hide()

  $.get "/session.json", (data) ->
    if data
      $('.logout').show()
      $('.navbar-collapse .nav').show()
      gitcycle.user = data
      gitcycle.events.trigger("user", data)
    else
      $('.login').show()
    $('.navbar-collapse .pull-right').show()