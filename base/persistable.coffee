module.exports = (userRepo) ->

  classProperties = 
    # Matcher keys specify which columns to match on
    # The values of those keys specify values to match
    # Example: User.where {id: '1234'}
    where: (matcher) ->
      userRepo.where(matcher)
      .then (results) =>
        users = []
        
        for u in results
          user = new @(u)
          users.push user

        users

    # A convenience method demonstrating the use of @where
    find: (id) ->
      @where({id: id})
      .then (results) ->
        user = results[0]
        user.getRoles()
        .then ->
          user

  instanceProperties =
    save: ->
      userRepo.save this

  extendWith = 
    classProperties: classProperties
    instanceProperties: instanceProperties