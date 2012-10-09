###
  fields.coffee
###
define [
  'cs!kind'
], (k) ->

    (maniford) ->
        abstr = {}
        concr = {}
        regst = {}
        proxy = {}

        {
            declare: (name, componentMode, spatialMode, temporalMode, dependentMode) ->
                kind = k.kind(componentMode, spatialMode, temporalMode, dependentMode)
                F = (coords) ->
                    proxy[name](coords)
                F.name = name
                F.kind = kind
                regst[name] = F
                F

            field: (name) ->
                regst[name]

            bind: (variable, func, dependencies) ->
                name = variable.name
                abstr[name] = func
                proxy[name] = func

            discreatize: (variable) ->
                name = variable.name
                func = abstr[name]
                concr[name] = []

                mesh = maniford.discreatize()
                for p in mesh.all()
                    concr[name].push func(p)

                f = (p) ->
                    nbrs = mesh.neighbors(p)
                    vals = [concr[p] for p in nbrs]
                    mesh.interpolate p, nbrs, vals

                proxy[name] = f
                variable.discreat = true
                variable.mesh = mesh

            init: (variable, tzero, func, dependencies) ->
                #TODO
        }
