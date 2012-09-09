###
  redis-fields.coffee
###
define [
  'exports'
  'cs!../config/index'
  'fs'
  'crypto'
  'redis'
], (m, cfg, fs, crypto, redis) ->

    m.load = (rc) ->
        shasum = crypto.createHash('sha1')
        fs.readFile 'redis/add.lua', 'utf8', (err, data) ->
            throw err if err
            m.ADD = data
        fs.readFile 'redis/prd.lua', 'utf8', (err, data) ->
            throw err if err
            m.PRD = data

    m.dim = 3
    m.lyt = [16, 16, 16]
    m.d1 = m.lyt[0]
    m.d2 = m.lyt[1]
    m.d3 = m.lyt[2]
    m.countdownA = m.d1 * m.d2
    m.countdownB = m.d1 * m.d2
    m.setup = (rc, callback) ->
        rc.hset('config', 'dim', m.dim)
        rc.hset('config', 'lyt:1', m.d1)
        rc.hset('config', 'lyt:2', m.d2)
        rc.hset('config', 'lyt:3', m.d3)

        all = m.d1 * m.d2 * m.d3
        while all
            affix = ''
            total = all

            reminder = total % m.d3
            total = (total - reminder) / m.d3
            reminder = m.d3 if reminder == 0
            affix = ":#{reminder}#{affix}"

            reminder = total % m.d2
            total = (total - reminder) / m.d2
            reminder = m.d2 if reminder == 0
            affix = ":#{reminder}#{affix}"

            reminder = total % m.d1
            total = (total - reminder) / m.d1
            reminder = m.d1 if reminder == 0
            affix = ":#{reminder}#{affix}"

            console.log affix
            rc.lpush('config:partition:1', affix)
            all = all - 1

        for x in [1 .. m.d1]
            for y in [1 .. m.d2]
                pipe = rc.multi()
                for z in [1 .. m.d3]
                    key = "a:#{x}:#{y}:#{z}"
                    console.log key
                    pipe.lpush(key, 3)
                    pipe.lpush(key, 2)
                    pipe.lpush(key, 1)
                pipe.exec (err) ->
                    throw err if err
                    console.log "a: #{m.countdownA}"
                    m.countdownA = m.countdownA - 1
                    callback() if m.countdownA + m.countdownB == 0

        for x in [1 .. m.d1]
            for y in [1 .. m.d2]
                pipe = rc.multi()
                for z in [1 .. m.d3]
                    key = "b:#{x}:#{y}:#{z}"
                    console.log key
                    pipe.lpush(key, 1)
                    pipe.lpush(key, 2)
                    pipe.lpush(key, 3)
                pipe.exec (err) ->
                    throw err if err
                    console.log "b: #{m.countdownB}"
                    m.countdownB = m.countdownB - 1
                    callback() if m.countdownA + m.countdownB == 0

    m.testAdd = (rc, callback) ->
        timeStart = (new Date()).getTime()
        console.log 'testing ADD'
        rc.eval m.ADD, 4, 'config', 'a', 'b', 'c', 1, (err, data) ->
            throw err if err
            timeEnd = (new Date()).getTime()
            console.log data, (timeEnd - timeStart) / 1000
            callback() if callback

    m.testProduct = (rc, callback) ->
        timeStart = (new Date()).getTime()
        console.log 'testing PRD'
        rc.eval m.PRD, 3, 'config', 'c', 'd', 2.0, 1, (err, data) ->
            throw err if err
            timeEnd = (new Date()).getTime()
            console.log data, (timeEnd - timeStart) / 1000
            callback() if callback

    m.main = (args...) ->
        rc = redis.createClient(cfg.redis.port, cfg.redis.host, cfg.redis.options)

        m.load rc
        m.setup rc, ->
            m.testAdd rc, ->
                m.testProduct rc, ->
                    rc.quit()

    m
