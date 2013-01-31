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
        canvas = $('#world-global').get(0)

        map = null
        frame = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]

        socket = io.connect()
        socket.on "connect", ->
            socket.on "begin", -> socket.emit "start", null
            socket.on "system", (data) ->
                $("#world-msg").html(data.time.toString())
                target = transformer.target(frame, data.lights, (data.time / planet.period))
                viewer.paint(target, map) if map
                $("#world-msg").html("no map") if not map
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

        R = 270
        coord = (e) ->
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
            [x / R, y / R]

        changeframe = (dx, dy) ->
            if dx > 0
                frame = rotater.left(frame, - dx)
            else
                frame = rotater.right(frame, dx)

            if dy > 0
                frame = rotater.up(frame, dy)
            else
                frame = rotater.down(frame, - dy)

        inDrag = false
        focus = null
        dragBegin = (e) ->
            [x, y] = coord(e)
            if x * x + y * y < 1
                focus = [x, y]
                inDrag = true
                canvas.css cursor: 'move'

        dragEnd = (e) ->
            inDrag = false
            focus = null
            canvas.css cursor: 'default'

        drag = (e) ->
            if inDrag
                [x, y] = coord(e)
                if x * x + y * y < 1
                    dx = x - focus[0]
                    dy = y - focus[1]
                    changeframe dx, dy
                else
                    inDrag = false
                    focus = null
                    canvas.css cursor: 'default'

        bean.add(
            $('#world-btn').get(0), 'click', (-> invoke())
        )
        bean.add(
            $('#world-global').get(0), 'mousedown', dragBegin
        )
        bean.add(
            $('#world-global').get(0), 'mouseup mouseout click', dragEnd
        )
        bean.add(
            $('#world-global').get(0), 'mousemove', drag
        )

       true
