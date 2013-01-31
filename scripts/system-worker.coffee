###
  system-worker.coffee

  a worker keeps the system info
###
define [
  'exports'
  'cs!../wahlque/physics/units/au'
  'cs!../wahlque/physics/units/si'
  'cs!../wahlque/math/geometry/vector3'
  'cs!../wahlque/universe/wahlque/system'
  'cs!../wahlque/universe/wahlque/planet/planet'
], (exports, au, si, vec3, system, planet) ->
    handle = 0
    tao = au.fromSI_T(planet.period / 30)
    start = ->
        evolve = ->
            system.step(tao)
            data =
                time: si.fromAU_T(system.time)
                positions:
                    [system.p1, system.p2, system.p3]
                lights:
                    [vec3.expand(system.u1, system.lum1), vec3.expand(system.u2, system.lum2)]
            self.postMessage({sys: data})

        setInterval(evolve, 1000)

    self.onmessage = (e) ->
        console.log("receive start")
        start()
        true

    exports

