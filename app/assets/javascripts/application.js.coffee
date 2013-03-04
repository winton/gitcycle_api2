#= require jquery
#= require lib/underscore
#= require lib/backbone
#= require twitter/bootstrap/bootstrap-tab

window.gitcycle = events: _.extend({}, Backbone.Events)

$ ->
  login  = $('.login').hide()
  logout = $('.logout').hide()

  $.get "/session.json", (data) ->
    if data
      $('.logout').show()
      $('.nav-collapse .nav').show()
      gitcycle.user = data
      gitcycle.events.trigger("user", data)
    else
      $('.login').show()
    $('.nav-collapse .pull-right').show()