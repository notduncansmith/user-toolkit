module.exports = (Extendable, uuid, db, modules) ->

  # Now User can be extended
  class User extends Extendable

    for m in modules
      @extend m.classProperties
      @include m.instanceProperties
    
    constructor: (user) ->
      props = Object.getOwnPropertyNames user

      for p in props
        @[p] = user[p]

      if not user.id?
        @id = uuid.v4()

    # Instance Methods
    save: ->
      db.save this

    fullName: ->
      @firstName + ' ' + @lastName

    stateAbbrev: ->
      abbrev = @state.charAt(0) + @state.charAt(1)
      abbrev.toUpperCase()

    fullAddress: ->
      address = "#{@streetOne}\n
      #{@streetTwo}\n
      #{@city}, #{@stateAbbrev()} #{@zip}
      "
      address.trim()

    # Class Methods

    # This takes a single object as an argument, matcher.
    # Matcher keys specify which columns to match on
    # The values of those keys specify values to match
    @where: (matcher) ->
      db.where(matcher)
      .then (result) ->
        new User(result)

    # A convenience method demonstrating the use of @where
    @find: (id) ->
      @where({id: id})