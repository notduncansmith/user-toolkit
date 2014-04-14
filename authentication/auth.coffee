module.exports = (Promise, userRepo, bcrypt) ->
  classProperties =
    authenticate: (username, password) ->
      userRepo.where {username: username}
      .then (user) ->
        new Promise (resolve, reject) ->
          u = user[0]
          bcrypt.compare password, u.password, (err, authenticated) ->
            if err?
              reject err
              return
            if authenticated is true
              resolve u
            else
              resolve 'Username or password incorrect'


  instanceProperties =
    newPassword: (newPass, andSave) ->
      new Promise (resolve, reject) =>
        bcrypt.hash newPass, 10, (err, hash) =>
          if err?
            reject err
            return
          
          @password = hash

          if andSave?
            @save()
            .then -> resolve @
            .catch (error) -> reject error
          else
            resolve hash

  extendWith = 
    classProperties: classProperties
    instanceProperties: instanceProperties

