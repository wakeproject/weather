###
  atmospheric-worker.coffee

  a worker keeps the system info
###
define [
  'exports'
  'cs!../wahlque/physics/units/au'
  'cs!../wahlque/physics/units/si'
  'cs!../wahlque/universe/wahlque/system'
  'cs!../wahlque/universe/wahlque/planet/planet'
  'cs!../wahlque/universe/wahlque/atmosphere'
], (exports, au, si, system, planet, atmosphere) ->
    handle = 0
    tao = planet.period / 3000
    start = ->
        evolve = ->
            atmosphere.step(tao)
            data =
                time: si.fromAU_T(system.time)
                positions:
                    [system.p1, system.p2, system.p3]
                lights:
                    [vec3.expand(system.u1, system.lum1), vec3.expand(system.u2, system.lum2)]
            self.postMessage({atm: data})

        setInterval(evolve, 1000)

    self.onmessage = (e) ->
        start()
        true


    exports

