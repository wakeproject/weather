###
  kind.coffee
###
define [
  'exports'
], (m, f) ->

    m.scalar      = 0
    m.vector      = 1
    m.surficial   = 0
    m.spatial     = 2
    m.constant    = 0
    m.temporal    = 4
    m.independent = 0
    m.dependent   = 8

    m
