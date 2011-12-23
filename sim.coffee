###
  sim.coffee
###
define [
  'exports'
  'cs!./config/index'
  'cs!./scripts/web-server'
], (m, c, w) ->

    m.main = (args...) ->
        w.main(c)

    m
