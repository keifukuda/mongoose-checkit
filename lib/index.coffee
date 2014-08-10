module.exports = (schema, options) ->

  Checkit = options || require 'checkit'

  schema.pre 'save', (next) ->

    rules = {}

    for key, path of schema.paths
      options = schema.paths[key].options

      if options.checkit?
        rules[key] = options.checkit

    checkit = Checkit rules

    checkit.run flatten @toObject()
    .then ->
      next()

    .catch (err) ->
      next err


flatten = (object, path = [], result = {}) ->

  for key, value of object
    _path = path.concat [key]

    if value instanceof Object
      result[_path.join('.')] = value
      flatten value, _path, result

    else
      result[_path.join('.')] = value

  return result

module.exports.flatten = flatten
