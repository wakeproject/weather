doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title 'Wahlque Weather Simulation'
    link rel: 'stylesheet', href: '/styles/style.css'
  body ->
    h1 'Wahlque Weather Simulation'
    div id: 'time'
    div id: 'lng'
    div id: 'lat'
    div id: 'msg'
    div id: 'links', ->
      ul ->
        li -> a href: '/atemp', -> 'global air temperature'
        li -> a href: '/stemp', -> 'global surface temperature'
        li -> a href: '/pressure', -> 'global air pressure'
        li -> a href: '/density', -> 'global air density'
        li -> a href: '/windx', -> 'global wind x'
        li -> a href: '/windy', -> 'global wind y'
        li -> a href: '/windz', -> 'global wind z'
        li -> a href: '/vatemp/0', -> 'verticle air temperature'
        li -> a href: '/vpressure/0', -> 'verticle air pressure'
        li -> a href: '/vdensity/0', -> 'verticle air density'
        li -> a href: '/vwindx/0', -> 'verticle wind x'
        li -> a href: '/vwindy/0', -> 'verticle wind y'
        li -> a href: '/vwindz/0', -> 'verticle wind z'

    @body
