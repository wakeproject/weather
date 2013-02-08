###
  kind.coffee
###
define [
  'exports'
], (m) ->

    m.scalar      =   0
    m.vector      =   1
    m.surficial   =   0
    m.spatial     =   1
    m.constant    =   0
    m.temporal    =   1
    m.independent =   0
    m.dependent   =   1

    m.kind = (component, spatial, temporal, dependent) ->
        component + 2 * (spatial + 2 * (temporal + 2 * dependent))

    m.isScalar = (kind) ->
        m.scalar == kind % 2

    m.isVector = (kind) ->
        m.vector == kind % 2

    m.isSurficial = (kind) ->
        m.surficial == Math.floor(kind / 2) % 2

    m.isSpatial = (kind) ->
        m.spatial == Math.floor(kind / 2) % 2

    m.isConstant = (kind) ->
        m.constant == Math.floor(kind / 4) % 2

    m.isTemporal = (kind) ->
        m.temporal == Math.floor(kind / 4) % 2

    m.isDependent = (kind) ->
        m.dependent == Math.floor(kind / 8) % 2

    m.isIndependent = (kind) ->
        m.independent == Math.floor(kind / 8) % 2

    m
