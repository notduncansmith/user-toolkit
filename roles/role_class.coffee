# NOT IN USE RIGHT NOW!!!

module.exports = (Extendable, db, Persistable) ->
  class Role extends Extendable
    constructor: (name) ->
      @extend Persistable
      @name = name


