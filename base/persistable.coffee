makeUsers = (rows, klass) ->
  users = []
      
  for u in rows
    user = new klass(u)
    users.push user

  users
  
module.exports = (userRepo) ->

  classProperties = 
    # Matcher keys specify which columns to match on
    # The values of those keys specify values to match
    # Example: User.where {id: '1234'}
    where: (matcher) ->
      userRepo.where(matcher)
      .then (results) => makeUsers(results, @)

    # A convenience method demonstrating the use of @where
    find: (id) ->
      @where({id: id})
      .then (results) ->
        user = results[0]
        .then ->
          user

    all: () ->
      userRepo.all()
      .then (results) => makeUsers(results, @)
        

    query: (sql) ->
      userRepo.query(sql)
      .then (results) => makeUsers(results, @)


  instanceProperties =
    save: ->
      userRepo.save @

    remove: ->
      userRepo.delete {id: @id}


  extendWith = 
    classProperties: classProperties
    instanceProperties: instanceProperties

