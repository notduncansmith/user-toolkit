module.exports = (Promise, roleRepo, user_roleRepo, uuid) ->
  classProperties = 
    createRole: (name) ->
      role = 
        name: name
        id: uuid.v4()

      roleRepo.save role

    renameRole: (id, newName) ->
      roleRepo.where {id: id}
      .then (role) ->
        role.name = newName
        roleRepo.save role

    getRoles: ->
      roleRepo.all()

  instanceProperties =
    addRole: (id) ->
      userRole = 
        userId: @id
        roleId: id
      
      user_roleRepo.save userRole
      .then () =>
        roleRepo.where {id: id}
      .then (role) =>
        @roles.push role.name

    removeRole: (id) ->
      user_roleRepo.delete {id: id}

    getRoles: ->
      user_roleRepo.where {userId: @id}
      .then (roles) ->
        promises = []
        for r in roles
          promises.push roleRepo.where({id: r.roleId})
        Promise.all(promises)
      .then (roles) =>
        @roles = roles[0]


  extendWith =
    classProperties: classProperties
    instanceProperties: instanceProperties