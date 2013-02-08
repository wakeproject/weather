###
  viewer.coffee

  view for generation
###
define [
  'underscore',
  'exports'
], (_, viewer) ->

    #size = 0.3
    canvas = document.getElementById("world-global")
    context = canvas.getContext("2d")
    canvas.width = 960
    canvas.height = 640

    terrain = (height, factor) ->
        r = 128
        b = 192
        r = Math.floor(height / 48 ) if height > 8192
        r = 255 if r > 255
        b = Math.floor(450 - height / 64) if height < 8192
        b = 255 if b > 255
        if height < 8192
            g = Math.floor((r + b) / 2.1)
        else
            g = Math.floor((r + b) / 1.3)
        g = 255 if g > 255

        factor = Math.sqrt(factor)
        factor = Math.sqrt(factor)
        r = Math.floor(r * factor)
        g = Math.floor(g * factor)
        b = Math.floor(b * factor)
        [r, g, b]

    viewer.paint = (params, data) ->
        context.clearRect(0, 0, 960, 640)
        [num, len, heights] = data
        for row in [0...num]
            for col in [0...num]
                lng = 2 * Math.PI * col / num
                lat = Math.PI * (0.5 - row / num)
                [position, factor] = params(lng, lat)
                [x, y] = position
                if x != -1 && y != -1
                    pos = row * num + row + col
                    height = heights[pos] / 64
                    [r, g, b] = terrain(height, factor)
                    context.fillStyle = "rgba(#{r}, #{g}, #{b}, 0.99)"
                    #context.fillRect(Math.floor(480 + 270 * size * x), Math.floor(320 + 270 * size * y), 7 * Math.sqrt(size), 7 * Math.sqrt(size))
                    context.fillRect(Math.floor(480 + 270 * x), Math.floor(320 + 270 * y), 7, 7)

        #size = size + 0.0005 if size < 1

    viewer