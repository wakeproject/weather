###
  main.coffee
###
define [
  'exports'
  'zappajs'
], (m, z) ->

    terrain = null
    tworker = new Worker 'scripts/terrain-worker.coffee'
    tworker.onmessage = (event) ->
        data = event.data
        if data.trn
            terrain = data.trn
    tworker.postMessage('start')

    system = null
    broadcast = null
    sworker = new Worker 'scripts/celestial-worker.coffee'
    sworker.onmessage = (event) ->
        data = event.data
        if data.sys
            system = data.sys
        if broadcast
            broadcast({system: system})
    sworker.postMessage('start')

    m.main = (ctx) ->
        settings = ctx.web
        z settings.domain, settings.port, ->
            @use 'bodyParser', 'methodOverride', @app.router, 'static'

            @configure
              development: => @use errorHandler: {dumpExceptions: on}
              production: => @use 'errorHandler'

            @get '/': -> @render 'index'

            @get '/atemp':     -> @render 'atemp'
            @get '/stemp':     -> @render 'stemp'
            @get '/pressure':  -> @render 'pressure'
            @get '/density':   -> @render 'density'
            @get '/windx':     -> @render 'windx'
            @get '/windy':     -> @render 'windy'
            @get '/windz':     -> @render 'windz'

            @get '/vatemp/:lng':    -> @render 'vatemp', @params.lng
            @get '/vpressure/:lng': -> @render 'vpressure', @params.lng
            @get '/vdensity/:lng':  -> @render 'vdensity', @params.lng
            @get '/vwindx/:lng':    -> @render 'vwindx', @params.lng
            @get '/vwindy/:lng':    -> @render 'vwindy', @params.lng
            @get '/vwindz/:lng':    -> @render 'vwindz', @params.lng

            @get '/terrain.jsonp': -> @jsonp terrain

            @on connection: -> @emit begin: "begin"
            @on start: ->
                if not broadcast
                    broadcast = (event) => @broadcast event


    m


