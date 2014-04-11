module.exports = (Promise, db, bcrypt) ->
  classProperties =
    authenticate: (username, password) ->
      db.where {username: username}
      .then (user) ->
        new Promise (resolve, reject) ->
          bcrypt.compare password, user.hashedPassword, (err, authenticated) ->
            if err?
              reject err
              return
            if authenticated is true
              resolve user
            else
              resolve 'Username or password incorrect'


  instanceProperties =
    newPassword: (newPass, andSave) ->
      new Promise (resolve, reject) ->
        bcrypt.hash newPass, 10, (err, hash) ->
          if err?
            reject err
            return
          if andSave?
            @hashedPassword = hash
            @save()
            .then -> resolve hash
            .catch (error) -> reject error
          else
            resolve hash

  extendWith = 
    classProperties: classProperties
    instanceProperties: instanceProperties

