###
  atmos.coffee
###
define [
  'exports'
  'cs!kind'
  'cs!../wahlque/math/field/fields'
  'cs!sphere'
  'cs!../wahlque/universe/wahlque/planet/planet'
  'cs!../wahlque/math/geometry/vector3'
], (m, k, f, s, p, v3) ->

    tao = 36
    fields = f(s, tao)

    R = 287
    c_v = 718

    omega = 2 * Math.PI / p.period

    m.p = f.def 'pressure', ['density', 'temperature'], (t, x, rho, T) ->
        R * rho(t, x) * T(t, x)

    m.V = f.def 'velocity', ['velocity', 'acceleration'], (t, x, V, dotV) ->
        [r, lambda, phi] = x
        if t < tao
            s.local x, [2.5 * (Math.sin(6 * phi + r / 10000 * Math.PI / 2) - 1), 0, 0]
        else
            v3.add
                V(t - tao, x),
                v3.expand dotV(t - tao, x), tao

    m.rho = f.def 'density', ['density', 'density-rate'], (t, x, rho, dotrho) ->
        [r, lambda, phi] = x
        if t < tao
            Math.exp(- r / 10000) * (1 - 0.05 * Math.cos(6 * lambda + r / 10000 * Math.PI / 2))
        else
            rho(t - tao, x) + tao * dotrho(t - tao, x)

    m.T = f.def 'temperature', ['temperature', 'temperature-rate'], (t, x, T, dotT) ->
        [r, lambda, phi] = x
        if t < tao
            278.15 - 0.006 * h - 80 * (1 - Math.cos(phi)) + 10 * Math.cos(lambda)
        else
            T(t - tao, x) + tao * dotT(t - tao, x)

    m.g = f.fld 'gravity', [], (t, x) ->
        [r, lambda, phi] = x
        s.local x, [
            0,
          - Math.sin(phi) * r * Math.cos(phi) * omega * omega,
            Math.cos(phi) * r * Math.cos(phi) * omega * omega - p.g
        ]

    m.C = f.def 'corioplis', ['velocity'], (t, x, V) ->
        [r, lambda, phi] = x
        Omega = s.local x, [
            0,
            Math.cos(phi) * omega,
            Math.sin(phi) * omega
        ]
        v3.cross(
            v3.expand(Omega, 2),
            V(t, x)
        )

    m.F = f.def 'viscosity', ['velocity', 'density'], (t, x, V, rho) ->
        [r, lambda, phi] = x
        nu = p.mu / rho(t, r, lambda, phi)
        v3.add
            (v3.expand s.laplacian(f.snapshot(t, V))(t, x, V(t, x), rho(t, x)), nu),
            (v3.expand s.grad(s.div(f.snapshot(t, V)))(t, x, V(t, x), rho(t, x)), nu / 3)

    m.Q = f.def 'heat', [], (t, r, lambda, phi) -> 0 #TODO

    m.dotV = f.def 'acceleration', ['gravity','density', 'pressure', 'corioplis', 'viscosity'], (t, x, g, rho, p, C, F) ->
        [r, lambda, phi] = x
        v3.add
             (g t, x),
             (v3.expand s.grad(f.snapshot(t, p)), - 1 / rho(t, x)),
             (C t, x),
             (F t, x)

    m.dotrho = f.def 'density-rate', ['velocity','density'], (t, x, V, rho) ->
        - rho(t, x) * s.div(f.snapshot(t, V))

    m.dotT = f.def 'temperature-rate', ['velocity', 'heat'], (t, x, V, Q) ->
        (Q(t, x) - R * T(t, x) * s.div(f.snapshot(t, V))) / c_v


    m
