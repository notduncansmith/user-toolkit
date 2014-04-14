module.exports = ( 
  Extendable
, uuid
, userRepo
, user_roleRepo
, Auth
, Persistable
, Roles
) ->

  # Now User can be extended
  class User extends Extendable

    @extend Auth
    @extend Persistable
    @extend Roles
    
    constructor: (user) ->
      props = Object.getOwnPropertyNames user

      for p in props
        @[p] = user[p]

      if not user.id?
        @id = uuid.v4()

      @roles = []

    # Instance Properties
    save: ->
      userRepo.save this

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