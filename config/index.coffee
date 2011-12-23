###
  index.coffee
###
define [
  'exports'
  'cs!./redis'
  'cs!./web'
  'cs!./workers'
], (m, redis, web, workers) ->

    redis: redis
    web: web
    workers: workers
