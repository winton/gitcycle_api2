$ ->
  setup = (user) ->
    text = $('#setup')
      .append(" #{user.gitcycle}")
      .html()
      .replace('<br>', "\n")
    #$('h3 span').append(clippy(text + "\n"))

  if gitcycle.user
    setup(gitcycle.user)
  else
    gitcycle.events.on("user", setup)

  $('.tabbable .nav a').click (e) ->
    e.preventDefault()
    $(@).tab('show')