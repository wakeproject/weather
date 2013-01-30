###
  csmain.coffee

  link for this section:
  http://playground.wahlque.org/tutorials/graphics/001-terrain-gen
###
define [
  'underscore'
  'domReady'
  'qwery'
  'bonzo'
  'bean'
  'reqwest'
  'socketio'
  'cs!/coffeescripts/rotater'
  'cs!/coffeescripts/transformer'
  'cs!/coffeescripts/viewer'
  'cs!/wahlque/universe/wahlque/planet/planet'
], (_, domReady, qwery, bonzo, bean, reqwest, io, rotater, transformer, viewer, planet) ->
    $ = (selector) -> bonzo(qwery(selector))

    domReady ->

        time = 0
        lights = null
        socket = io.connect()
        map = null
        frame = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
        socket.on "connect", ->
            socket.on "begin", -> socket.emit "start", null
            socket.on "system", (data) ->
                time = data.time
                lights = data.lights
                $("#world-msg").html(time)
                target = transformer.target(frame, lights, (time / planet.period))
                viewer.paint(target, map) if target
            true

        invoke = ->
            reqwest
                url: '/terrain.jsonp?callback=?'
                type: 'jsonp'
                success:  (resp) ->
                  map = resp
                  $("#world-msg").html('Done!')
            $("#world-msg").html('Initializting the terrain data')
            true

        changeframe = (e) ->
            canvas = $('#world-global').get(0)
            width = canvas.width
            height = canvas.height

            x = y = 0
            if e.pageX || e.pageY
              x = e.pageX
              y = e.pageY
            else
              x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
              y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
            x -= canvas.offsetLeft
            y -= canvas.offsetTop
            x = x - width / 2
            y = y - height / 2

            if x > 0
                frame = rotater.left(frame, - x / width * 2)
            else
                frame = rotater.right(frame, x / width * 2)

            if y > 0
                frame = rotater.up(frame, y / height * 2)
            else
                frame = rotater.down(frame, - y / height * 2)

        bean.add(
            $('#world-btn').get(0), 'click', (-> invoke())
        )
        bean.add(
            $('#world-global').get(0), 'click', changeframe
        )

       true
