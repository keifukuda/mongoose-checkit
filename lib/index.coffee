flat = require 'flat'
flatten = flat.flatten

module.exports = (schema, options) ->

  Checkit = options || require 'checkit'

  schema.pre 'save', (next) ->

    rules = {}

    for key, path of schema.paths
      options = schema.paths[key].options

      if options.checkit?
        rules[key] = options.checkit

    checkit = Checkit rules

    checkit.run flatten @toJSON()
    .then ->
      next()

    .catch (err) ->
      next err

module.exports.flatten = flatten
