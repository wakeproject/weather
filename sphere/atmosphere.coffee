###
  atmosphere.coffee
###
define [
  'exports'
  'cs!kind'
  'cs!sphere'
  'cs!../wahlque/universe/wahlque/planet/planet'
  'cs!../wahlque/math/geometry/vector3'
], (m, k, s, p, v3) ->

    m.g = s.field 'gravity', k.vector, k.surficial, k.constant, k.dependent

    m.V   = s.field 'velocity',    k.vector, k.spatial, k.temporal, k.independent
    m.rho = s.field 'density',     k.scalar, k.spatial, k.temporal, k.independent
    m.p   = s.field 'pressure',    k.scalar, k.spatial, k.temporal, k.independent
    m.T   = s.field 'temperature', k.scalar, k.spatial, k.temporal, k.independent
    m.q   = s.field 'humidity',    k.scalar, k.spatial, k.temporal, k.independent

    m.C = s.field 'corioplis', k.vector, k.spatial, k.temporal, k.dependent
    m.F = s.field 'viscosity', k.vector, k.spatial, k.temporal, k.dependent

    m.Q = s.field 'heat',  k.scalar, k.spatial, k.temporal, k.dependent
    m.S = s.field 'vapor', k.scalar, k.spatial, k.temporal, k.dependent


    gravity = (lambda, phi, r) ->
        omega = 2 * Math.PI / p.period
        sphere.local lambda, phi, r, [
            0,
          - Math.sin(phi) * r * Math.cos(phi) * omega * omega,
            Math.cos(phi) * r * Math.cos(phi) * omega * omega - p.g
        ]

    corioplis = (t, lambda, phi, r, V) ->
        omega = 2 * Math.PI / p.period
        Omega = sphere.local lambda, phi, r, [
            0,
            Math.cos(phi) * omega,
            Math.sin(phi) * omega
        ]
        v3.cross(
            v3.expand(Omega, 2),
            V(t, lambda, phi, r)
        )

    viscosity = (t, lambda, phi, r, V, rho) ->
        nu = p.mu / rho(t, lambda, phi, r)
        v3.add (
            v3.expand(sphere.laplacian(V)(t, lambda, phi, r, V, rho), nu),
            v3.expand(sphere.grad(sphere.div(V))(t, lambda, phi, r, V, rho), nu / 3),
        )


    s.bind m.g, gravity
    s.bind m.C, corioplis, m.V
    s.bind m.F, viscosity, m.V, m.rho

    s.bind m.Q, (t, lambda, phi, r) -> 0 #TODO
    s.bind m.S, (t, lambda, phi, r) -> 0 #TODO

    s.init m.V, (t, lambda, phi, r) -> sphere.local lambda, phi, r, [
        2.5 * (Math.sin(6 * phi + r / 10000 * Math.PI / 2) - 1), 0, 0
    ]

    s.init m.rho, (t, lambda, phi, r) ->
        Math.exp(- r / 10000) * (1 - 0.05 * Math.cos(6 * lambda + r / 10000 * Math.PI / 2))

    s.init m.p, (t, lambda, phi, r) ->
        293 * Math.exp(- r / 10000) * (1 - 0.05 * Math.cos(6 * phi + h / 10000 * Math.PI / 2)) \
            * (278.15 - 0.006 * h - 80 * (1 - Math.cos(phi)) + 10 * Math.cos(lambda))

    s.init m.T, (t, lambda, phi, r) ->
        278.15 - 0.006 * h - 80 * (1 - Math.cos(phi)) + 10 * Math.cos(lambda)

    s.init m.q, (t, lambda, phi, r) -> 0 #TODO

    m
