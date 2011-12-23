###
  sim.coffee
###
define [
  'exports'
  'cs!./scripts/web-server'
], (m, w, c) ->

    m.main = (args...) ->
        ctx = {}
        w.main(ctx)

    m
