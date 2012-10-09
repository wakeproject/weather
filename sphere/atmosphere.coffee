###
  atmos.coffee
###
define [
  'exports'
  'cs!kind'
  'cs!fields'
  'cs!sphere'
  'cs!../wahlque/universe/wahlque/planet/planet'
  'cs!../wahlque/math/geometry/vector3'
], (m, k, f, s, p, v3) ->

    m.g = f.declare 'gravity', k.vector, k.spatial, k.constant, k.independent

    m.V   = f.declare 'velocity',    k.vector, k.spatial, k.temporal, k.independent
    m.rho = f.declare 'density',     k.scalar, k.spatial, k.temporal, k.independent
    m.p   = f.declare 'pressure',    k.scalar, k.spatial, k.temporal, k.independent
    m.T   = f.declare 'temperature', k.scalar, k.spatial, k.temporal, k.independent
    m.q   = f.declare 'humidity',    k.scalar, k.spatial, k.temporal, k.independent

    m.C = f.declare 'corioplis', k.vector, k.spatial, k.temporal, k.dependent
    m.F = f.declare 'viscosity', k.vector, k.spatial, k.temporal, k.dependent

    m.Q = f.declare 'heat',  k.scalar, k.spatial, k.temporal, k.dependent
    m.S = f.declare 'vapor', k.scalar, k.spatial, k.temporal, k.dependent


    omega = 2 * Math.PI / p.period

    gravity = (lambda, phi, r) ->
        s.local lambda, phi, r, [
            0,
          - Math.sin(phi) * r * Math.cos(phi) * omega * omega,
            Math.cos(phi) * r * Math.cos(phi) * omega * omega - p.g
        ]

    corioplis = (t, r, lambda, phi, V) ->
        Omega = s.local lambda, phi, r, [
            0,
            Math.cos(phi) * omega,
            Math.sin(phi) * omega
        ]
        v3.cross(
            v3.expand(Omega, 2),
            V(t, r, lambda, phi)
        )

    viscosity = (t, r, lambda, phi, V, rho) ->
        nu = p.mu / rho(t, r, lambda, phi)
        v3.add (
            v3.expand(s.laplacian(V)(t, r, lambda, phi, V, rho), nu),
            v3.expand(s.grad(s.div(V))(t, r, lambda, phi, V, rho), nu / 3),
        )


    f.bind m.g, gravity
    f.bind m.C, corioplis, m.V
    f.bind m.F, viscosity, m.V, m.rho

    f.bind m.Q, (t, r, lambda, phi) -> 0 #TODO
    f.bind m.S, (t, r, lambda, phi) -> 0 #TODO

    f.init m.V, (t, r, lambda, phi) -> s.local lambda, phi, r, [
        2.5 * (Math.sin(6 * phi + r / 10000 * Math.PI / 2) - 1), 0, 0
    ]

    f.init m.rho, (t, r, lambda, phi) ->
        Math.exp(- r / 10000) * (1 - 0.05 * Math.cos(6 * lambda + r / 10000 * Math.PI / 2))

    f.init m.p, (t, r, lambda, phi) ->
        293 * Math.exp(- r / 10000) * (1 - 0.05 * Math.cos(6 * phi + h / 10000 * Math.PI / 2)) \
            * (278.15 - 0.006 * h - 80 * (1 - Math.cos(phi)) + 10 * Math.cos(lambda))

    f.init m.T, (t, r, lambda, phi) ->
        278.15 - 0.006 * h - 80 * (1 - Math.cos(phi)) + 10 * Math.cos(lambda)

    f.init m.q, (t, r, lambda, phi) -> 0 #TODO

    m
