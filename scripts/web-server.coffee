###
  main.coffee
###
define [
  'exports'
  'zappa'
], (m, z) ->

    m.main = (ctx) ->
        z ->
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

            @on connection: ->
              @emit welcome: {time: new Date()}

            @on shout: ->
              @broadcast shout: {@id, text: @data.text}

    m


