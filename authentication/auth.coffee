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
    newPassword: (newPass) ->
      new Promise (resolve, reject) ->
        bcrypt.hash newPass, 10, (err, hash) ->
          if err?
            reject err
          else
            resolve hash

  extendWith = 
    classProperties: classProperties
    instanceProperties: instanceProperties

